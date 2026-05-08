# CLAUDE4 — Backlog technique

## Fait

### Module Documents (fichiers telechargeables dans TipTap)
**Statut** : FAIT (8 mai 2026)

Probleme : pas moyen pour un admin client d'integrer un PDF (plaquette, tarif, CGV) ou un fichier bureautique (DOCX, XLSX) dans un article ou une page. Seules les images passaient par le module Medias.

Solution :
- **Entite** `Document` separee de `Media` (id, name, file_name, extension, mime_type, size, created_at). Pas de pipeline WebP, pas d'images responsives — usage 100% telechargement.
- **Stockage** : `public/documents/files/` (separe de `medias/`). Le dossier est gitignore sur main et force-tracke sur les branches `bw_*`.
- **Migration** : `Version20260508090000` — table `document` avec collation `utf8mb4_unicode_ci` (compatible MariaDB local + MySQL 8 OVH).
- **`DocumentService`** : `formatSize()` (1,2 Mo / 340 Ko), `iconForExtension()` (mappage vers `fa-file-pdf`, `fa-file-word`, `fa-file-excel`, `fa-file-powerpoint`, `fa-file-archive`, `fa-file-lines`), constantes `MAX_FILE_SIZE_BYTES` (25 Mo) et `ALLOWED_EXTENSIONS` (pdf, doc, docx, xls, xlsx, ppt, pptx, odt, ods, odp, zip, rar, 7z, csv, txt).
- **`DocumentMetadataListener`** (postPersist + postUpdate) : extrait mime/size/extension du fichier sur disque apres l'upload via `Symfony\Mime\MimeTypes`. Auto-flush avec guard anti-boucle (le pattern de `MediaUploadListener`).
- **Admin CRUD** : `DocumentCrudController` avec `EasyCorp\Bundle\EasyAdminBundle\Form\Type\FileUploadType` (pas de FileField natif dans EasyAdmin 4.12 — passage par `TextField::setFormType(FileUploadType::class)`). AdminHelpTrait + validation File contraintes (extensions whitelist + max 25 Mo).
- **API TipTap** : `DocumentApiController` (ROLE_AUTHOR) — `GET /admin/api/document/list?q=` (recherche avec limite 200) + `POST /admin/api/document/upload` (multipart, valide les contraintes, slugifie + uuid, persiste, retourne JSON enrichi). L'upload depuis l'editeur cree le document en bibliotheque automatiquement.
- **Extension TipTap** : `assets/admin/extensions/document.js` — `Node.create({ name: 'document', group: 'block', atom: true, draggable: true })`. Render HTML : `<a class="block-document" download data-document-id data-extension>` avec icone + nom + meta + action download.
- **`tiptap-editor.js`** : nouveau bouton `fa-file-arrow-down` dans le groupe Media + entree `/document` dans le slash menu. `openDocumentModal()` avec liste recherchable + zone d'upload integree (bouton "Choisir un fichier" + champ nom optionnel).
- **`BlockRenderer::renderDocument()`** : produit le meme markup HTML que TipTap cote serveur pour le cache `content` (sanitizer-friendly). Attention au rawurlencode du basename pour gerer les espaces.
- **`html_sanitizer.yaml`** : whitelist enrichie avec `a[class, href, target, rel, download, data-document-id, data-extension]` + `i[class]` pour passer la carte sans strip.
- **CSS** : `.block-document` dans `assets/css/base/blocks.scss` (front, custom properties theme) + version simplifiee dans `tiptap-editor.scss` pour l'editeur. Item de modal `.tiptap-doc-item` avec icone + nom + meta uppercase.
- **Aide contextuelle** : `DocumentCrudController::getHelpData()` (panel lateral), section `#guide-documents` dans `templates/admin/guide/index.html.twig` avec 6 sous-sections (formats, methodes upload, nom affiche, rendu front, 2 tips), 2 nouvelles astuces dans le tableau `TIPS` du dashboard, mention dans `ArticleCrudController` et `PageCrudController` (section "L'editeur de contenu" + tip dedie).
- **Menu admin** : entree `Documents` (icone `fa-file-arrow-down`) sous `Contenu`, entre `Medias` et la section `Classification`.

### Protection des slugs cote admin (SlugFieldHelperTrait)
**Statut** : FAIT (30 avr. 2026)

Probleme : un admin client (ROLE_ADMIN) avait modifie un slug sans comprendre l'impact, cassant l'URL de sa page (404 sur les liens externes + casse du menu pour les pages indexees dans la nav).

Solution :
- Nouveau trait `App\Controller\Admin\Trait\SlugFieldHelperTrait` avec une methode `slugField(targetField, description, hideOnIndex)` factoree
- **ROLE_ADMIN ou inferieur** : `hideOnForm()` — slug invisible en edition, donc impossible a modifier (le slug se genere a la creation depuis le targetField et reste fige)
- **ROLE_FREELANCE+** (revendeur, super admin) : visible avec un help d'avertissement fort en rouge expliquant les consequences (404, perte SEO)
- Applique a 15 CrudControllers : Article, Page, Categorie, Tag, TagGroup, Service, Event, Faq, FaqCategory, Portfolio (Item + Category), Product (+ Category), Directory (Entry + Category)

Pour une vraie solution durable (laisser modifier sans risque), voir « Redirections 301 automatiques » dans le backlog A faire.

### Familles de tags (TagGroup) + filtres annuaire dynamiques
**Statut** : FAIT (29 avr. 2026)
- **Entite** `TagGroup` (id, name, slug, color, displayOrder, description) + `TagGroupRepository` (findAllOrdered, findActiveForDirectory)
- **Tag** : nouvelle relation ManyToOne nullable vers TagGroup (rattachement optionnel, ON DELETE SET NULL) + relation inverse vers DirectoryEntry
- **DirectoryEntry** : nouvelle ManyToMany vers Tag (table `directory_entry_tag`)
- Migration : `Version20260429075920` — 3 nouvelles tables/colonnes, retrocompat totale (tag.tagGroup nullable)
- **TagRepository** : `findCloudForDirectory()`, `getMultiSourceCounts()` (compteurs articles + directory + products + portfolio)
- **DirectoryEntryRepository** : `findFiltered()` (recherche + categorie + tags en intersection), `findActiveByTag()`
- **Admin** : `TagGroupCrudController` (ColorField, IntegerField order, panneau aide complet), `TagCrudController` enrichi (champ tagGroup + tips + section "Familles" dans help), `DirectoryEntryCrudController` enrichi (champ tags autocomplete + section "Filtres par tags" dans help)
- **Menu admin** : sous-menu `Classification` (Tags + Familles de tags) sous Contenu, ROLE_ADMIN. Tags reste accessible aussi via le sous-menu Blog (raccourci).
- **Front annuaire** : `DirectoryController` lit `?tags[]=slug` et genere les filtres par famille automatiquement. Cumul avec recherche + categorie. Bandeau pills colore par famille (CSS via `--tg-color`).
- **Sidebar blog** : `tag_cloud.html.twig` regroupe par famille des qu'au moins un tag a une famille (sinon rendu plat historique).
- **Page `/tag/{slug}`** : sections multi-source (Annuaire + Articles), depend des modules actifs. Plus de blocage si module blog desactive.
- **Fiche annuaire** : tags du membre groupes par famille, chaque pill est un lien vers `/annuaire?tags[]=slug`.
- **CSS** : `directory.scss` (`directory-tag-filters__*`), `tags.scss` (`tag-cloud-group__*`) avec custom properties.
- **Guide d'aide admin** : nouvelle section `#guide-tags` (avant Medias) expliquant tags + familles + cas d'usage + bonnes pratiques. Section Portfolio : mention "tags partages" enrichie pour citer l'annuaire.

### Favicon auto-generation depuis le logo (CRUD Site)
**Statut** : FAIT (commit 6f9fa04)
- `FaviconGeneratorService` : genere 7 favicons PNG (16, 32, 96, 150, 180, 192, 512) + `site.webmanifest` + `browserconfig.xml`
- `SiteLogoListener` (postPersist/postUpdate) : regenere a chaque sauvegarde du Site
- Champ `logoDark` (ManyToOne Media, nullable) pour le footer fond sombre
- `base.html.twig` : package favicon complet, plus de condition if/else
- 5 footers themes : `site.logoDark ?? site.logo` fallback
- SiteCrudController : sous-sections (Nom, Visuels, Coordonnees), champ favicon manuel supprime

### Systeme d'override client templates/client/
**Statut** : FAIT
- Priorite : client/ > themes/{theme}/ > themes/default/
- 5 includes mis a jour (header, footer, home, contact, blog)
- ThemeService.hasClientTemplate() ajoute
- .gitignore sur main, trackable sur branches bw_* via `git add -f`

### Fix categories portfolio ecrasees par base.html.twig
**Statut** : FAIT (commit 86cca12)
- Variable `categories` dans PortfolioController renommee en `portfolioCategories`
- `base.html.twig` ligne 7 ecrasait la variable avec les categories blog (widget)

### Module Annuaire (DirectoryEntry + DirectoryCategory)
**Statut** : FAIT
- Entites : `DirectoryEntry` (firstName, lastName, slug, photo, jobTitle, company, bio, email, phone, city, website, linkedin, facebook, instagram, category, user, isActive, isFeatured, SeoTrait) + `DirectoryCategory`
- Repositories : findAllActive, findActiveByCategory, searchActive, findFeatured, findByUser, findAllActiveForSitemap
- Admin CRUDs : DirectoryEntryCrudController (5 panels + ImageField direct) + DirectoryCategoryCrudController — avec getHelpData()
- DashboardController : menu Annuaire (Fiches + Categories)
- Front controller : `/annuaire` (liste + filtres categorie + recherche), `/annuaire/{slug}` (fiche detail 2 colonnes + sidebar), `/annuaire/ma-fiche` (edition membre connecte)
- Form : DirectoryEntryType avec upload photo
- Templates : index (filtres pills + search + grille cards), show (layout 2 colonnes blog-like + sidebar contact/liens), card (entreprise en titre, "En savoir plus"), edit (formulaire membre)
- CSS : `directory.scss` enrichi (cards, filtres, detail, sidebar sticky) + overrides par theme dans chaque theme.css
- Overrides theme : Corporate (horizontal, serif, uppercase), Artisan (gros radius, terre, serif), Vitrine (epure, outline, letter-spacing), Starter (liste brut, pas de cards, opacity hover), Moderne (dark mode, gradient, glow)
- Sitemap : entrees directory integrees
- Bootstrap Icons : installe via npm, importe dans main.scss

### Bootstrap Icons → SVG inline
**Statut** : FAIT
- Supprime `@import "~bootstrap-icons/font/bootstrap-icons.css"` de `main.scss` (98 Ko CSS + font woff2)
- `IconExtension.php` : fonction Twig `bi('name', 'class', 'size')` avec cache memoire
- 21 SVGs copies dans `templates/icons/` (seules les icones utilisees)
- 6 templates migres : `<i class="bi bi-xxx">` → `{{ bi('xxx') }}`
- `.bi-svg` : classe CSS minimale pour le sizing des SVG inline
- `services.yaml` : IconExtension enregistre avec `$projectDir`

### Optimisation performances PageSpeed v1 (commit d780414)
**Statut** : FAIT
- **Dockerfile** : ajout `libwebp-dev` + `--with-webp` — GD ne supportait pas WebP, toute la conversion echouait silencieusement
- **ResponsiveImageExtension** : parametre `eager` pour les images LCP (`loading="eager" fetchpriority="high"`)
- **Homepage** : hero + about utilisent `responsive_img()` avec srcset WebP au lieu des JPG bruts
- **`.htaccess`** : cache 1 an immutable + gzip pour OVH Apache (le .htaccess Symfony par defaut n'avait aucun header cache)
- **`base.html.twig`** : Google Fonts en preload non-blocking + `display=swap`
- **`webpack.config.js`** : corejs mis a jour de 3.23 a 3.30
- **`.browserslistrc`** : ciblage navigateurs modernes pour reduire les polyfills (~58 Ko)

### Optimisation performances PageSpeed v2 (7 avr. 2026)
**Statut** : FAIT
**Score** : Mobile 72 → 83 | Desktop ~90 → 99

**Theme CSS inline (elimine 10.4s de render-blocking)**
- `base.html.twig` : `<link href="/theme-css/{slug}">` remplace par `<style>{{ source('themes/' ~ _theme ~ '/theme.css') }}</style>`
- La route Symfony `app_theme_css` reste en place pour preview/debug
- Fonctionne pour tous les themes, pas seulement vitrine

**Import selectif Bootstrap (app.scss)**
- Import module par module au lieu de `@import 'bootstrap'` complet
- 7 modules supprimes (button-group, progress, modal, tooltip, popover, carousel, spinners)
- CSS passe de 42 Ko a 38 Ko
- Tentative async (vendor.css) abandonnee : causait CLS 1.171

**Auto-resize images a l'upload**
- `MediaProcessorService` : `downscaleOriginal()` redimensionne a 1920px max avant conversion WebP
- `SiteLogoListener` : `downscaleLogo()` redimensionne logos a 128px max de hauteur (apres generation favicons)
- `services.yaml` : SiteLogoListener enregistre avec `$mediaDirectory`

**Fix MediaUploadListener (bug webpFileName non persiste)**
- Injection EntityManager + `$this->em->flush()` apres `setWebpFileName()`
- Guard `$this->processing` pour eviter boucle infinie (flush declenche postUpdate)
- Avant le fix : les images uploadees via admin n'avaient pas de WebP en BDD

**Logo dynamique (fonction Twig logo_img)**
- `ResponsiveImageExtension` : fonction `logo_img(media, displayHeight, alt, cssClass)`
- Calcule width dynamiquement via `getimagesize()` et le ratio reel du fichier
- Remplace `width="auto" height="42"` (non reconnu par les navigateurs)
- 5 headers + 5 footers themes migres vers `{{ logo_img() }}`

**Accessibilite (98 → 100)**
- `base.html.twig` : `<main>` ajoute autour de `{% block body %}`
- 6 headers themes : `aria-label="Rechercher"` sur les boutons de recherche SVG

## A faire

### Redirections 301 automatiques sur changement de slug
**Priorite** : Moyenne (resout le risque de casse SEO/liens externes)

Aujourd'hui, le slug est `hideOnForm` pour ROLE_ADMIN client (introduit pour eviter qu'un client ne casse ses URLs sans comprendre). Mais ROLE_FREELANCE+ peut toujours modifier, et un changement reste destructeur (404 sur tous les liens externes).

**Solution propre** : entite `Redirect` (old_path, new_path, entity_type, entity_id, created_at), listener `preUpdate` Doctrine sur les entites a slug qui detecte le changement et insere une ligne. EventSubscriber `kernel.exception` qui capte les 404, lookup en base, retourne `RedirectResponse(301)` vers le nouveau path.

**Bonus** : permet aussi de taper directement des redirections custom dans l'admin (CRUD Redirect) — ex: redirection d'une URL externe migree vers un nouveau site.

**Cible** : 6-8h. A planifier des qu'un client demande la modification d'une URL importante.

### Widgets configurables par zone (homepage + sidebar)
**Priorite** : Basse (besoin futur, pas urgent)

Aujourd'hui les nuages de tags et autres widgets sont places via `{% include %}` dans les templates (hard-codes). Pour donner aux clients/freelances la liberte de placer un nuage par famille (ex: « Villes » sur la home, « Metiers » dans la sidebar annuaire) sans toucher au code, il faudrait :

- Entite `WidgetZone` (slug de zone : `homepage_top`, `sidebar_blog`, etc.)
- Entite `Widget` (zone, type: tag_cloud / categories / featured / ..., config JSON, position, isActive)
- Type de widget « Nuage de tags » avec config : famille a filtrer, nombre max, contexte (articles/directory/...)
- Templates: `{% widgets_for 'homepage_top' %}` qui itere et rend chaque widget actif
- CRUD admin avec drag & drop pour reordonner

**Cible** : 1-2 jours. A planifier quand un client demande explicitement « je veux un nuage X a tel endroit ».

### Performances mobile — pistes pour passer au-dessus de 90
**Priorite** : Basse (score actuel 83, acceptable)
**Prerequis** : migration vers VPS ou ajout CDN (Cloudflare gratuit)

Le score mobile est plafonne par l'hebergement OVH mutualise :
- **TTFB ~150-320ms** : le serveur met du temps a repondre. Un VPS ou un CDN reduirait le FCP (actuellement 2.6s)
- **CSS inutilise (34 Ko)** : Bootstrap 25 modules charges, tous utilises sur au moins une page. PurgeCSS possible mais risque de casser des pages non testees
- **JS inutilise (79 Ko)** : core-js polyfills + Bootstrap JS. Deja optimise (import selectif des composants JS)

**Migration VPS attendue** : a la premiere vente client. Le VPS devrait ameliorer le TTFB et donc le FCP/LCP, ce qui pourrait suffire pour atteindre 90+.

### Scores actuels (7 avr. 2026)

| | Desktop | Mobile |
|---|---------|--------|
| Performances | **99** | **83** |
| Accessibilite | **100** | **100** |
| Bonnes pratiques | **100** | **100** |
| SEO | **100** | **100** |
