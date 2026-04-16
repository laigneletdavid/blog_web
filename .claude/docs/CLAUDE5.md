# CLAUDE5 — Sessions du 8 au 16 avril 2026

## Fait

### Fix editeur Tiptap vide sur les pages legales
**Statut** : FAIT
- **Probleme** : les pages legales (mentions, confidentialite, CGU) avaient du HTML dans `content` mais `blocks` (JSON Tiptap) etait null. L'editeur admin affichait un contenu vide.
- **`Page::getBlocksJson()`** : fallback sur `content` (HTML) quand `blocks` est null
- **`tiptap-editor.js::parseContent()`** : si `JSON.parse` echoue, retourne le HTML brut (Tiptap parse le HTML nativement)
- **Flux** : a l'ouverture, Tiptap charge le HTML. A la sauvegarde, Tiptap convertit en JSON `blocks`, et `ContentSanitizeListener` regenere `content` depuis `blocks`. Apres la premiere sauvegarde, `blocks` est rempli et le fallback n'est plus utilise.

### Stats & Analytics — filtrage bots et admins
**Statut** : FAIT

**Champ `is_bot` sur PageView**
- `PageView.php` : champ `isBot` (bool, default false, indexe `idx_pageview_is_bot`)
- Migration `Version20260408055018` : ajout colonne `is_bot`

**Filtrage dans PageViewSubscriber**
- Admins (`ROLE_AUTHOR` et superieur) : visites ignorees, pas d'enregistrement
- Bots : detectes via 25 patterns User-Agent (googlebot, bingbot, crawl, spider, lighthouse, pagespeed, gtmetrix, semrush, ahrefs, gptbot, claudebot, etc.)
- Bots enregistres avec `is_bot = true`, visiteurs normaux avec `is_bot = false`
- User-Agent vide = considere comme bot
- Injection de `Security` pour verifier le role

**Requetes Repository filtrees**
- `countToday()`, `countThisWeek()`, `countThisMonth()`, `uniqueVisitorsToday()` : filtrent `is_bot = false`
- `dailyStats()` : retourne 3 colonnes — `views` (humains), `visitors` (humains uniques), `bot_views` (bots)

**Graphe dashboard : 3e courbe Robots**
- `admin-dashboard.js` : dataset "Robots" en orange pointille (`#f59e0b`, borderDash `[3, 3]`)
- Affiche le trafic bot separement des visiteurs humains

### Compteur de pages vues
**Statut** : FAIT

**Repository**
- `topPages(limit, period, year)` : top pages les plus vues, filtrable par periode (today, week, month, year, all) et annee
- `countViewsByUrl(url)` : nombre de vues humaines pour une URL donnee
- `resolvePeriodDate()` : methode privee de resolution des dates de filtre

**Dashboard admin — tableau "Pages les plus vues"**
- Tableau avec URL + nombre de vues
- Select periode : Aujourd'hui / Cette semaine / Ce mois / Cette annee / Tout
- Select annee : annee courante + 3 ans precedents
- Soumission automatique au changement de filtre (`onchange`)
- Message "Aucune visite pour cette periode" si vide
- `AdminStatsService::getDashboardStats()` accepte `$topPagesPeriod` et `$topPagesYear`
- `DashboardController::index()` lit les query params `period` et `year` via `request_stack`

**Front articles — compteur de vues**
- `ArticleController::show()` : passe `viewCount` au template via `PageViewRepository::countViewsByUrl()`
- `article/show.html.twig` : affiche "X vue(s)" dans les meta de l'article (apres le temps de lecture)
- N'affiche rien si 0 vues

**CRUD admin — colonne "Vues"**
- `ArticleCrudController` : colonne `IntegerField` virtuelle "Vues" avec `formatValue` qui appelle `countViewsByUrl('/article/' ~ slug)`
- `PageCrudController` : idem avec `countViewsByUrl('/' ~ slug)`
- Colonnes visibles dans la liste, masquees dans les formulaires

### Contenu bw_front (branche client)
**Statut** : FAIT
- Section Services : titre "Comment ca se passe concretement" + sous-titre
- Hero badge : "Site en ligne en 1/2 journee"
- Chiffres cles : "1/2 j pour etre en ligne"
- Bloc CTA : "en une demi-journee, apres validation de votre contenu"

### Publication programmee (lazy scheduling)
**Statut** : FAIT
- **Champ `scheduled_at`** (DateTime, nullable) sur `Article` + migration `Version20260409085027`
- **`ArticleRepository::findScheduledReady()`** : articles non publies avec `scheduled_at <= NOW()`
- **`ScheduledPublicationSubscriber`** (kernel.request) : a chaque visite front, verifie si des articles programmes sont prets. Si oui : `published = true`, `published_at = scheduled_at`, flush, notification abonnes
- **Pas de cron** : fonctionne nativement en multi-site, delenche par la premiere visite apres la date programmee
- **Logique admin (`handleScheduledPublication`)** : date future → force brouillon (meme si "Publie" coche). Date passee → publication immediate. Publication manuelle → nettoie `scheduled_at`
- **CRUD** : champ DateTimeField "Publication programmee" dans le panneau Parametres, aide et tips mis a jour
- Exclut assets et outils dev (`/_wdt`, `/_profiler`, `/build/`, etc.)
- Erreurs de notification catchees (ne bloquent pas la publication)

### Fix sommaire (TOC) — entites HTML dans les titres
**Statut** : FAIT
- **Probleme** : les apostrophes dans les titres du sommaire s'affichaient en `&#039;` au lieu de `'`
- **Cause** : `extractToc()` dans `AppExtension.php` utilisait `strip_tags()` sans decoder les entites HTML. Twig echappait ensuite le texte, laissant les entites brutes.
- **Fix** : ajout `html_entity_decode()` apres `strip_tags()` dans `extractToc()`

### Fix widget "Dernier article" — image debordante
**Statut** : FAIT
- **Probleme** : l'image du widget "Dernier article" dans la sidebar debordait de la colonne
- **Cause** : `.widget_article_img` avait `width: 100%` dans un `flex-row`, prenant toute la largeur
- **Fix template** : typo `felx-row` → `flex-row`, ajout `flex-shrink-0` sur l'image, `overflow-hidden` sur le texte
- **Fix CSS** : `.widget_article_img` passe a `width: 8rem; min-width: 8rem` (taille fixe), `overflow: hidden` sur le parent `.widget_article`

## Scores actuels (8 avr. 2026)

| | Desktop | Mobile |
|---|---------|--------|
| Performances | **99** | **85** |
| Accessibilite | **100** | **100** |
| Bonnes pratiques | **100** | **100** |
| SEO | **100** | **100** |

### Premier deploiement client — Les Pros d'Ici (bw_pro_dici)
**Statut** : FAIT
- **Client** : AlexMB (Alexandra Michalski Beaudouin) — annuaire de professionnels Nord-Ouest toulousain
- **Theme** : artisan | Couleurs : Terracotta `#E2725B`, Vert mousse `#41521F`, Sable `#F9F7F2`
- **Modules** : blog + directory
- **Domaine** : prodici.comwebsolutions.fr
- **Setup complet** : BDD, client:setup, modules, categories blog (4), pages legales, 2 admins, reCAPTCHA
- **Home custom** : `templates/client/home.html.twig` avec 7 familles metiers, textes rediges, icones SVG inline
- **CSS client** : `templates/client/theme.css` (hero, CTA, logo, footer, familles metiers)
- **Deploy OVH** : clone branche + deploy-ovh.sh --init + dump SQL importe

### Corrections post-deploiement (main)
**Statut** : FAIT

**Mecanisme client/theme.css**
- `base.html.twig` : charge `templates/client/theme.css` en dernier dans `<head>` (apres theme.css)
- Fichier vide sur main, personnalise sur les branches client
- Evite de modifier les fichiers CMS (theme.css, _header, _footer) sur les branches bw_*

**Corrections globales**
- `.gitattributes` : force LF sur les .sh (fix `^M` sur OVH)
- `.gitignore` : supprime la regle `templates/client/*` (bloquait les overrides client)
- `Makefile` : ajout target `make db-client` (cree BDD via root + grant privileges + migrate)
- `CreateSuperAdminCommand` : ajout options CLI `--email`, `--password`, `--first-name`, `--last-name`
- `ResponsiveImageExtension::logoImg()` : `displayHeight=0` par defaut → pas de width/height inline, CSS gere la taille
- `global.scss` : override `.btn-primary` et `.btn-outline-primary` avec `var(--primary)` (fix boutons bleus Bootstrap)
- 6 footers themes : ajout lien "Developpe avec BlogWeb" (blogweb.comwebsolutions.fr)
- `SETUP.md` : `make db-client` remplace `make db`, section Troubleshooting complete, documentation override client

**7 icones SVG ajoutees** (templates/icons/)
- `tools.svg`, `heart-pulse.svg`, `laptop.svg`, `palette.svg`, `cup-hot.svg`, `truck.svg`, `briefcase.svg`

### Merge tactique des branches
**Statut** : FAIT
- `main → bw_front` : merge propre, zero conflit
- `main → bw_pro_dici` : conflit `.gitignore` resolu (garde main), overrides migres de theme.css artisan vers client/theme.css, fichiers CMS revertes a leur etat main

### Liens internes Tiptap — enrichissement
**Statut** : FAIT
- **Probleme** : le picker de lien interne Tiptap ne listait que Pages, Articles, Categories, Services. Les pages en dur (Accueil, Contact...) et les modules activables (produits, events, portfolio, directory) etaient absents.
- **`StaticPageEnum`** (nouveau) : enum centralise des pages "en dur" (HOME, CONTACT, SEARCH, BLOG_INDEX, SERVICE_INDEX, EVENT_INDEX, PORTFOLIO_INDEX, FAQ_INDEX, PRODUCT_INDEX, DIRECTORY_INDEX, CART) avec `label()`, `routeName()`, `requiredModule()`. Calque sur `SystemPageEnum`.
- **`LinkApiController`** : ajoute un groupe "Raccourci" (pages statiques filtrees par module actif) + support Produits (CATALOGUE|ECOMMERCE), Evenements (EVENTS), Realisations (PORTFOLIO), Membres (DIRECTORY). `try/catch` silencieux sur les routes absentes.
- Comportement existant inchange (Pages/Articles/Categories/Services toujours listes sans check module pour non-regression).

### Systeme d'icones — catalogue + picker
**Statut** : FAIT

**Probleme initial** : mix de Font Awesome et bootstrap-icons CSS bundle, 21 SVG custom dans `templates/icons/`, pas de picker UI. Champs `icon` en BDD stockes au format FA (`fas fa-search`).

**Catalogue elargi a 57 icones** (templates/icons/ + public/icons/)
- Import depuis `node_modules/bootstrap-icons/icons/` (deja en devDep)
- 50 icones essentielles : navigation (chevrons, arrows, list, x, check, three-dots...), actions (trash, plus, download, eye, gear, pencil), contenu (image, folder2, link-45deg, calendar3, clock, tag), contact (envelope, telephone, geo-alt-fill, globe), user (person, person-circle), social (facebook, instagram, linkedin, youtube, twitter-x, whatsapp), ecommerce (cart, bag, credit-card, truck), feedback (info-circle, exclamation-triangle, check-circle-fill, question-circle), reaction (star, heart, share)
- 7 extras heritees (box-arrow-up-right, person-fill, telephone-fill, geo-alt, lock, lightning-charge, pencil-square)
- **`make icons-sync`** : target Makefile qui copie `templates/icons/*.svg` → `public/icons/*.svg` (cp -u)

**Hybride deux systemes**
- **Templates/CRUD/composants** : `{{ bi('envelope') }}` (currentColor, inchange)
- **Contenu editorial Tiptap** : `<img src="/icons/envelope.svg">` via Image picker

**Integration Tiptap — Extension InlineImage**
- Extension custom `InlineImage` (extend Image) : `inline:true`, `group:'inline'`, `atom:true`, `priority:200`, `parseHTML` sur `img[src^="/icons/"]`
- `addOptions` override pour forcer inline=true dans la parent-chain Tiptap
- Nouveau bouton toolbar "icone" + modal dedie avec grille + recherche
- Endpoint `/admin/api/icons` (scan `public/icons/*.svg`)
- `BlockRenderer.php` : handler `inlineImage` + fallback retro-compat (type:image avec src=/icons/ rendu inline sans `<figure>`)
- CSS inline (admin tiptap-editor.scss + front main.scss apres imports) : `width: 1.2em; vertical-align: -0.15em; margin: 0 0.15em; border-radius: 0; max-width: none`

**IconPickerField EasyAdmin (nouveau)**
- `src/Field/IconPickerField.php` : custom field implementant `FieldInterface` avec `FieldTrait`, base TextType, attributs `data-icon-picker="true"`
- `assets/admin/icon-picker.js` + scss : scanne les inputs `data-icon-picker`, ajoute bouton "Choisir" + zone preview live, modal avec grille reutilisant `/admin/api/icons`
- Entry webpack `admin_icons` + chargement via `DashboardController::configureAssets`
- **4 CRUDs migres** : ServiceCrudController, FaqCrudController, DirectoryCategoryCrudController, PortfolioCategoryCrudController (TextField → IconPickerField)
- **4 templates migres** vers `{{ bi() }}` : _services_grid, faq/index, _faq_accordion, portfolio/index
- Hack `replace({'bi bi-': '', 'bi-': ''})` supprime de directory/index

**Commande migration format**
- `app:icons:migrate-format [--dry-run]` : convertit les valeurs de champ `icon` en BDD
- Supporte Font Awesome (`fas fa-search` → `search`), bootstrap-icons prefixe (`bi bi-xxx` → `xxx`), ou deja au format court
- Mapping FA → bi couvre ~50 icones communes (fa-search→search, fa-edit→pencil, fa-bolt→lightning-charge, fa-map-marker-alt→geo-alt-fill, etc.)
- Valeurs inconnues listees mais non modifiees (traitement manuel)
- Parcourt Service, Faq, DirectoryCategory, PortfolioCategory

**Nettoyage**
- `templates/base_feettrip.html.twig` supprime (orphelin)
- `bootstrap-icons` deplace en `devDependencies` dans `package.json` (source pour `make icons-sync` en dev, exclu en prod via `npm install --production`)

### Fix dropdown nav — alignement cross-themes
**Statut** : FAIT
- **Probleme** : sur theme artisan (et autres), les liens de nav avec sous-menu (PARENT▼) etaient decales par rapport aux liens simples. Cause : pattern HTML `<div class="dropdown"><a class="<nav>__link dropdown-toggle">` fait que le `<div>` wrapper devient l'enfant flex direct au lieu du `<a>`. Padding et alignement vertical du `<a>` restent internes, decalage visible (surtout sur navs avec gap explicite).
- **Fix global** dans `assets/css/base/header.scss` (apres la closing `}` de `.header`) :
  ```scss
  header nav .dropdown:has(> .dropdown-toggle) {
      display: inline-flex;
      align-items: stretch;
      > .dropdown-toggle { display: inline-flex; align-items: center; }
  }
  ```
- `:has()` cible uniquement les wrappers de liens nav, sans toucher `.header-search.dropdown` (structure differente)
- S'applique a tous les themes (default, vitrine, corporate, moderne, artisan). Starter non concerne (pas de support sous-menu).

### Bio annuaire — Tiptap
**Statut** : FAIT
- **Migration** `Version20260416073057` : ajoute colonne `blocks JSON NULL` sur `directory_entry`
- **`DirectoryEntry`** : champ `blocks` (JSON) + getters/setters + virtual `getBlocksJson()/setBlocksJson()` (pattern Article/Service) + alias `getContent()/setContent()` qui pointent vers `bio` (pour ContentSanitizeListener sans cas special)
- **`ContentSanitizeListener`** : ajout DirectoryEntry au `instanceof` check. Compile `blocks` JSON en HTML stocke dans `bio` (via les alias content/bio).
- **`DirectoryEntryCrudController`** : `TextareaField('bio')` → `TextareaField('blocksJson')` avec `data-tiptap-editor` (admin)
- **`DirectoryEntryType`** (form user) : idem
- **Template `directory/edit.html.twig`** : charge `admin_editor` webpack entry (CSS + JS Tiptap) via blocks `stylesheets` et `javascripts`. Form utilise `form.blocksJson`.
- **Template `directory/show.html.twig`** : `entry.bio|raw` au lieu de `nl2br` (HTML safe via sanitizer)

### Champs requis fiche annuaire
**Statut** : FAIT
- `DirectoryEntry` : `Assert\NotBlank` ajoute sur `company` (necessaire au slug genere via `setTargetFieldName('company')`)
- `DirectoryEntryCrudController` : `setRequired(true)` + `setHelp` sur le TextField company (force l'asterisque visible — le `nullable: true` ORM faisait que Symfony deduisait `required: false` malgre le NotBlank)
- `DirectoryEntryType` : `'required' => true` + help sur firstName, lastName, company

### Liens contact responsives (mailto / tel)
**Statut** : FAIT
- **Probleme** : sur desktop, clic sur `mailto:` / `tel:` declenche le client mail systeme / dialer (intrusif sur poste, mal configure souvent). Sur mobile c'est ok.
- **`assets/js/contact-link-handler.js`** (nouveau) : intercepte les clics sur `a[href^="mailto:"]` et `a[href^="tel:"]` UNIQUEMENT sur desktop (`matchMedia('(hover: hover) and (pointer: fine)')`). Copie dans le presse-papier + toast feedback 1.8s. Fallback `execCommand` pour vieux navigateurs / contextes non-securises. Listener delegue sur `document` (gere les liens dynamiques).
- Importe dans `assets/app.js` (front entry global)
- **`directory/show.html.twig`** : ajoute `noreferrer` au `noopener` sur les liens externes (website, linkedin, facebook, instagram) — best practice securite

## A faire

### Bug editeur Tiptap — verifier sur toutes les pages
**Priorite** : Moyenne
- Le fix fallback HTML fonctionne pour les pages legales
- Verifier que toutes les pages (articles, services, events, portfolio, FAQ) se comportent correctement
- Verifier que la sauvegarde depuis l'editeur met bien a jour `content` via `ContentSanitizeListener`

### Merge chantier icones vers branches clients
**Priorite** : Haute
- `main → bw_front` : merge + run `app:icons:migrate-format` + deploy OVH
- `main → bw_pro_dici` : merge + run `app:icons:migrate-format` + deploy OVH
- Verifier en prod : `make icons-sync` (ou que le deploy-ovh.sh copie bien public/icons/)

### Stats — ameliorations futures
**Priorite** : Basse
- Reclasser les anciens bots en BDD (`UPDATE page_view SET is_bot = 1 WHERE LOWER(user_agent) REGEXP '...'`) ou purger la table
- Ajouter un filtre "pages vs articles" dans le tableau top pages
- Export CSV des statistiques

### Performances mobile — pistes pour 90+
**Priorite** : Basse — attendre migration VPS
- TTFB OVH mutualise (~150-320ms) plafonne le FCP
- CSS inutilise Bootstrap (34 Ko) — PurgeCSS possible mais risque
- JS inutilise (79 Ko) — deja optimise
- CDN Cloudflare (gratuit) en complement du VPS
