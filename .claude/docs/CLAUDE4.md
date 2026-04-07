# CLAUDE4 — Backlog technique

## Fait

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
