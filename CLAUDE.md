# Blog & Web — CMS MVP

## Objectif

CMS Symfony prêt à vendre. Un site propre, sécurisé, avec SEO intégré, clonable en 30 minutes pour chaque nouveau client. On vend du service (installation + personnalisation), pas du SaaS.

> Le plan complet (provisioning auto, dashboard super-admin, abonnements, IA) est dans `CLAUDE_FULL.md` — à dérouler plus tard si la demande est là.

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS
- **ORM** : Doctrine ORM 3.3 + Migrations
- **Admin** : EasyAdmin Bundle 4.12
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Stimulus/Hotwire
- **Templates** : Twig 3
- **BDD** : MariaDB 11
- **Infra** : Docker (PHP-FPM 8.4 + Nginx + MariaDB 11 + Mailpit)
- **Mailer** : Brevo (via `symfony/brevo-mailer`)

## Architecture

### Clone par client

Chaque client = un clone du repo avec sa BDD et son `.env.local`.

```
/var/www/clients/
├── client-alpha/     → clone du repo, BDD blog_alpha, .env.local
├── client-beta/      → clone du repo, BDD blog_beta, .env.local
└── ...
```

Installation d'un nouveau client :
```bash
git clone git@repo:blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
cp .env.local.example .env.local    # Éditer : BDD, APP_SECRET, domaine
make up && make db
# → Se connecter à /admin, personnaliser (logo, couleurs, infos)
```

### Conventions future-proof (pour multi-tenant plus tard)

- Toujours utiliser `SiteContext::getCurrentSite()`, jamais `->find(1)` en dur
- Toutes les requêtes passent par les méthodes Repository
- Entités de contenu marquées `TenantAwareInterface`
- Le jour J : ajouter `site_id` + Doctrine Filter global (voir `CLAUDE_FULL.md`)

### Personnalisation client

Via CSS custom properties chargées depuis l'entité `Site` :
```twig
<style>:root {
  --primary: {{ site.primaryColor|default('#0455C0') }};
  --secondary: {{ site.secondaryColor|default('#F1A341') }};
  --font-family: {{ site.fontFamily|default("'Expletus Sans', sans-serif") }};
}</style>
```

Les SCSS utilisent `var(--primary)` — personnalisation sans rebuild Webpack.

---

## Plan d'action MVP

> **Temps réel Phase 1 : ~2h30** (estimé initialement ~4 jours)

### Phase 1 — Docker + Upgrade + Sécurité + Nettoyage ✅ (~2h30)

#### 1.1 Docker complet

Conteneuriser toute l'app. Tout tourne dans Docker, zéro dépendance locale.

**Stack Docker :**

| Service | Image | Port | Rôle |
|---------|-------|------|------|
| `php` | PHP 8.4-FPM (custom) | 9000 (interne) | App Symfony + Composer |
| `nginx` | Nginx Alpine | 8080 → 80 | Reverse proxy |
| `db` | MariaDB 11 | 3306 | Base de données |
| `node` | Node 20 Alpine | - | Build Webpack (run only) |
| `mailer` | Mailpit | 1025/8025 | Capture emails dev |

- [x] Créer `docker/php/Dockerfile` — PHP 8.4-FPM + extensions (pdo_mysql, intl, gd, zip, opcache, apcu)
- [x] Créer `docker/nginx/default.conf` — Config Nginx Symfony
- [x] Réécrire `docker-compose.yml` — Tous les services (port DB : 3307 externe)
- [x] Créer `docker-compose.override.yml` — Dev (Xdebug, Node pour assets)
- [ ] Créer `docker-compose.prod.yml` — Prod (opcache max, restart always)
- [x] Créer `Makefile` — `make up`, `make down`, `make sh`, `make db`, `make cc`, `make assets`
- [x] Créer `.dockerignore`
- [x] Créer `.env.local.example` — Template pour chaque client
- [x] Configurer `DATABASE_URL=mysql://app:app@db:3306/blog_web`
- [x] Configurer `doctrine.yaml` → `server_version: 'mariadb-11.0.0'`, `enable_lazy_ghost_objects`, `type: attribute`

**Fichiers :**
- Nouveau : `docker/php/Dockerfile`, `docker/nginx/default.conf`
- Réécrit : `docker-compose.yml`, `docker-compose.override.yml`
- Nouveau : `docker-compose.prod.yml`, `Makefile`, `.dockerignore`, `.env.local.example`

#### 1.2 Upgrade PHP 8.4 + Symfony 7.4 LTS

- [x] `composer.json` : `php >= 8.4`, `symfony/* 7.4.*`, Doctrine ORM ^3.3, EasyAdmin ^4.12
- [x] `composer update` dans le container PHP
- [x] Adapter les deprecations Symfony 7 : `SecurityRequestAttributes`, `eraseCredentials(): void`, `Routing\Attribute\Route`
- [x] Supprimer `sensio/framework-extra-bundle` + config
- [x] Supprimer `doctrine/annotations` (tout est en attributs PHP 8)
- [x] Déplacer dépendances dev (`phpunit`, `phpstan`, `browser-kit`, etc.) en `require-dev`
- [x] `config/routes/annotations.yaml` : `annotation` → `attribute`
- [x] `config/bundles.php` : supprimé `SensioFrameworkExtraBundle`
- [x] Tester le build Webpack Encore
- [x] Installer `symfony/brevo-mailer` pour l'envoi d'emails
- [x] Configurer `MESSENGER_TRANSPORT_DSN=doctrine://default`
- [x] Configurer sessions persistantes (`save_path` dans `framework.yaml`)

**Fichiers modifiés :** `composer.json`, `composer.lock`, `symfony.lock`, `config/bundles.php`, `config/packages/doctrine.yaml`, `config/packages/framework.yaml`, `config/packages/messenger.yaml`, `config/routes/annotations.yaml`, `.env`, `src/Entity/User.php`, `src/Security/UserAuthenticator.php`

#### 1.3 Failles de sécurité critiques

- [x] **Reset password** : `ResetPasswordBundle` installé, controller token-based (`ResetPasswordController`), route `/find` supprimée, templates créés
- [x] **IDOR profil** : ownership check `$user !== $this->getUser()` + `#[IsGranted('ROLE_USER')]` sur `UserController`, route `edit_pass` supprimée
- [x] **XSS** : `HtmlSanitizer` via Doctrine listener `ContentSanitizeListener` (prePersist/preUpdate) sur Article et Page
- [x] **Null checks** : guard null avant `$article->getSlug()`, 404 propre sur `ArticleController` et `PageController`
- [x] **CSRF** : `csrf_protection: true` activé dans `framework.yaml`
- [x] **Comment auth** : formulaire commentaire affiché uniquement si user connecté
- [x] **Admin password** : ajout `updateEntity()` dans `UserCrudController` — hash à la création ET à l'édition
- [x] **Commande super admin** : `app:create-super-admin` pour créer le compte initial
- [x] **Commande init site** : `app:init-site` pour configurer le site
- [x] **Rôle SUPER_ADMIN** : ajouté dans `RoleEnum` + `role_hierarchy` dans `security.yaml`

**Fichiers créés :** `src/Command/CreateSuperAdminCommand.php`, `src/Command/InitSiteCommand.php`, `src/Controller/ResetPasswordController.php`, `src/Entity/ResetPasswordRequest.php`, `src/Repository/ResetPasswordRequestRepository.php`, `src/EventListener/ContentSanitizeListener.php`, `config/packages/html_sanitizer.yaml`, `templates/reset_password/`
**Fichiers modifiés :** `HomeController`, `UserController`, `ArticleController`, `PageController`, `UserCrudController`, `framework.yaml`, `security.yaml`, `RoleEnum.php`, `DashboardController`, `base.html.twig`, `login.html.twig`
**Fichiers supprimés :** `config/packages/sensio_framework_extra.yaml`

#### 1.4 Nettoyage code mort ✅

- [x] Supprimer `DataUserRepository.php`, `User1Type.php`, `FindUserType.php`
- [x] Supprimer import `ContainerCxexD47` dans `ArticleCrudController`
- [x] Supprimer/finaliser stubs (`CommentController`, `TagController`)
- [x] Supprimer méthode morte `DashboardController::url()`
- [x] Nettoyer templates stub (`site/`, `tag/`, `media/index.html.twig`)
- [x] Corriger typo `caterogires.html.twig` → `categories.html.twig`
- [x] Corriger `mappedBy: 'User'` → `'user'` dans `User.php`
- [x] Supprimer boucle morte `CategorieController::show()`
- [x] Corriger `CategorieRepository::findByArticle()` (DQL invalide)
- [x] Déplacer `phpdocumentor` et `phpstan` en `require-dev`
- [x] Recréer `comment/index.html.twig` comme template partiel de commentaire
- [x] Corriger syntaxe `{% include %}` commentaires dans `article/show.html.twig`
- [x] Corriger typo `<artcle>` → `<article>` dans `article/show.html.twig`
- [x] Corriger type hints `?user` → `?User` dans `Comment.php`

**Fichiers supprimés :** `DataUserRepository.php`, `User1Type.php`, `FindUserType.php`, `CommentController.php`, `TagController.php`, `templates/site/`, `templates/tag/`, `templates/media/`
**Fichiers modifiés :** `ArticleCrudController`, `DashboardController`, `CategorieController`, `CategorieRepository`, `User.php`, `Comment.php`, `article/show.html.twig`, 4 templates (renommage widget categories)
**Fichiers créés :** `templates/comment/index.html.twig` (template partiel commentaire)

#### 1.5 Conventions future-proof ✅

- [x] Créer `src/Service/SiteContext.php` — `getCurrentSite()` avec cache mémoire
- [x] Remplacer tous les `->find(1)` par `SiteContext` (DashboardController, InitSiteCommand)
- [x] Remplacer `setEntityId(1)` par `setEntityId($siteContext->getCurrentSiteId())`
- [x] Créer `src/Model/TenantAwareInterface.php` (interface vide, préparation)
- [x] Vérifier que toutes les requêtes passent par les repositories

**Fichiers créés :** `src/Service/SiteContext.php`, `src/Model/TenantAwareInterface.php`
**Fichiers modifiés :** `DashboardController`, `InitSiteCommand`

#### 1.6 Corrections fonctionnelles ✅

- [x] `AppExtension::menuLink()` : retourne `'#'` si aucun article/catégorie/page associé
- [x] Null check sur `widget_service.findLastArticle` dans `base.html.twig` (fait en 1.3)
- [x] `Categorie.featured_media` : SMALLINT → vraie relation ManyToOne Media
- [x] Index UNIQUE sur `article.slug`, `page.slug`, `categorie.slug`, `tag.slug`
- [x] Index sur `article.published`, `menu.is_visible`
- [x] Password min → 12 caractères (RegistrationFormType + PassType)

**Migration :** `Version20260310051607.php` (⚠️ à exécuter manuellement)
**Fichiers modifiés :** `AppExtension.php`, `Categorie.php`, `Article.php`, `Page.php`, `Tag.php`, `Menu.php`, `RegistrationFormType.php`, `PassType.php`

---

### Phase 2 — Module SEO (~2 jours)

#### 2.1 SeoTrait

- [ ] Créer `src/Entity/Trait/SeoTrait.php` : `seoTitle(70)`, `seoDescription(160)`, `seoKeywords(255)`, `noIndex(bool)`, `canonicalUrl(255)`
- [ ] Appliquer sur `Article`, `Page`, `Categorie`
- [ ] Migration Doctrine

#### 2.2 Champs SEO + thème sur Site

- [ ] `defaultSeoTitle`, `defaultSeoDescription`, `googleAnalyticsId`, `googleSearchConsole`, `favicon` (FK Media)
- [ ] `primaryColor`, `secondaryColor`, `fontFamily` (pour personnalisation client)

#### 2.3 Rendu Twig

- [ ] Block `{% block seo %}` dans `base.html.twig` : `<title>`, `<meta description>`, `<meta keywords>`, `<link canonical>`, `<meta robots>`
- [ ] Open Graph : `og:title`, `og:description`, `og:image`, `og:url`, `og:type`
- [ ] Twitter Cards : `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`
- [ ] Schema.org JSON-LD : `Article`, `BreadcrumbList`
- [ ] Fallback : `seoTitle` → `title` → `site.defaultSeoTitle`
- [ ] Injection CSS custom properties depuis `Site` (couleurs, font)

#### 2.4 Sitemap XML

- [ ] `SitemapController` → route `/sitemap.xml`
- [ ] Articles + pages publiés + catégories avec `<lastmod>`, `<changefreq>`, `<priority>`

#### 2.5 Admin SEO

- [ ] Onglet "SEO" dans `ArticleCrudController`, `PageCrudController`, `CategorieCrudController`
- [ ] Compteurs de caractères (70 pour title, 160 pour description)
- [ ] Champs SEO + couleurs/fonts dans `SiteCrudController`

---

### Phase 3 — Thème personnalisable (~1 jour)

#### 3.1 CSS custom properties

- [ ] Modifier `assets/css/base/variables.scss` : remplacer `$bw-blue` etc. par `var(--primary)`, `var(--secondary)`
- [ ] Conserver les valeurs SCSS comme fallback pour le build
- [ ] Vérifier que tous les composants utilisent les CSS custom properties

#### 3.2 Personnalisation admin

- [ ] `SiteCrudController` : `ColorField` pour primaire/secondaire, choix de font, logo
- [ ] Le thème s'applique via les custom properties injectées dans `base.html.twig`

---

### Phase 4 — Éditeur TipTap + UX + Stats + Notifications

> Ordre optimisé pour minimiser les allers-retours entre fichiers.

#### 4.0 Nettoyage & simplification admin (avant tout le reste)

**Nettoyage code mort :**
- [ ] Supprimer `LikeCrudController.php` (stub vide, pas dans le menu)
- [ ] Supprimer `OptionCrudController.php` (stub vide, pas dans le menu)
- [ ] Supprimer imports morts dans `MenuCrudController.php` (`use http\Env\Request`, `use phpDocumentor\...\Property`)
- [ ] Corriger typo `SiteCrudController` : "Goolge map" → "Google Maps"
- [ ] Corriger labels : "Toutes les médias" → "Tous les médias", "Toutes les utilisateurs" → "Tous les utilisateurs"

**Simplification menu sidebar :**
- [ ] Réorganiser `DashboardController::configureMenuItems()` :
  ```
  Tableau de bord
  Aller sur le site
  ─── Contenu ───
  Articles                    (sans sous-menu "Ajouter" — le bouton EasyAdmin existe déjà)
  Pages                       (idem)
  Médias                      (idem)
  Commentaires
  ─── Administration ───      (ROLE_ADMIN)
  Identité du site
  Navigation                  (menus — un seul lien)
  Utilisateurs
  ─── Aide ───
  Aide                        (garder — module à créer plus tard)
  ```
- [ ] Supprimer les sous-items "Ajouter un article/page/média" (redondants)
- [ ] Supprimer le lien "Formation" (pointe vers google.com)
- [ ] Supprimer le lien "Contact support" (pointe vers la home)
- [ ] Garder le lien "Aide" (module aide à créer ultérieurement)

**Simplification gestion des menus :**
- [ ] Fusionner `MenuArticleCrudController`, `MenuPageCrudController`, `MenuCategoriesCrudController` en un seul `MenuCrudController` avec un champ dropdown `type` (Article / Page / Catégorie / Lien externe)
- [ ] Supprimer les 3 controllers spécialisés après fusion

**Formulaire article avec panels :**
- [ ] `ArticleCrudController` : organiser en panels EasyAdmin
  - Panel "Contenu" : titre, contenu (TipTap — sera ajouté en 4.5)
  - Panel "Paramètres" : catégories, image mise en avant, texte mis en avant, publié oui/non
  - Panel "Avancé" (collapsed) : slug (auto-généré), date de publication
- [ ] `published_at` auto-rempli quand `published` passe à `true` (dans `persistEntity`/`updateEntity`)
- [ ] `PageCrudController` : idem (panels adaptés)

**Dashboard utile :**
- [ ] Remplacer le texte placeholder par des raccourcis rapides : "Nouvel article", "Nouvelle page"
- [ ] Garder les 3 cards existantes (Réglages, Pages, Blog) mais supprimer les textes trop longs

**Fichiers supprimés :** `LikeCrudController.php`, `OptionCrudController.php`, `MenuArticleCrudController.php`, `MenuPageCrudController.php`, `MenuCategoriesCrudController.php`
**Fichiers modifiés :** `DashboardController.php`, `MenuCrudController.php`, `ArticleCrudController.php`, `PageCrudController.php`, `SiteCrudController.php`, `templates/admin/dashboard.html.twig`

#### 4.1 Entités + Migration (tout le schéma d'un coup)

- [ ] `Article.php` : ajouter `blocks` (JSON, nullable) + `draftBlocks` (JSON, nullable)
- [ ] `Page.php` : idem
- [ ] Créer `src/Entity/PageView.php` : `url`, `ipHash` (string, IP anonymisée SHA-256), `userAgent`, `referer`, `createdAt` — index sur `created_at` + `url`
- [ ] Créer `src/Repository/PageViewRepository.php` : méthodes `countToday()`, `countThisWeek()`, `countThisMonth()`, `topArticles(limit)`, `dailyStats(days)`
- [ ] Générer et exécuter la migration Doctrine

**Fichiers créés :** `PageView.php`, `PageViewRepository.php`, migration
**Fichiers modifiés :** `Article.php`, `Page.php`

#### 4.2 Services backend

- [ ] Créer `src/Service/BlockRenderer.php` — convertit `blocks` JSON → HTML pour le cache `content`
  - Gère les types : `text` (HTML brut TipTap), `image` (figure+img+figcaption), `video` (iframe YouTube/Vimeo), `quote` (blockquote+cite), `code` (pre+code), `separator` (hr)
- [ ] Modifier `src/EventListener/ContentSanitizeListener.php` — si `blocks` non vide, compiler via `BlockRenderer::toHtml()` → `setContent(html)`
- [ ] Créer `src/EventSubscriber/PageViewSubscriber.php` — log chaque requête front (exclure /admin, /_wdt, assets) dans `PageView`, IP hashée SHA-256
- [ ] Créer `src/Service/ArticleNotificationService.php` — envoie un email (Brevo) aux users `articles=true` quand un article est publié

**Fichiers créés :** `BlockRenderer.php`, `PageViewSubscriber.php`, `ArticleNotificationService.php`
**Fichiers modifiés :** `ContentSanitizeListener.php`

#### 4.3 Webpack + dépendances npm

- [ ] `package.json` : ajouter `@tiptap/core`, `@tiptap/starter-kit`, `@tiptap/extension-image`, `@tiptap/extension-youtube`, `@tiptap/extension-placeholder`, `@tiptap/extension-typography`, `sortablejs`
- [ ] `webpack.config.js` : ajouter entry `admin_blocks` → `./assets/admin/blocks-editor.js`
- [ ] npm install dans le container node

**Fichiers modifiés :** `package.json`, `webpack.config.js`

#### 4.4 Éditeur TipTap (JS + CSS admin)

- [ ] Créer `assets/admin/blocks-editor.js` — éditeur TipTap full-page intégré dans EasyAdmin
  - TipTap avec StarterKit + Image + YouTube + Placeholder + Typography
  - Toolbar : gras, italique, titres (H2/H3), listes, citation, lien, image, vidéo, code, séparateur
  - Bouton image → ouvre modal bibliothèque Media (fetch `/admin/api/media/list`)
  - Bouton vidéo → prompt URL YouTube/Vimeo
  - Slash commands (`/`) : image, vidéo, citation, code, séparateur
  - Sauvegarde dans hidden input JSON (format TipTap natif)
  - Autosave localStorage toutes les 30s + indicateur visuel "Brouillon sauvegardé"
  - Restauration : si localStorage contient un brouillon plus récent, proposer "Restaurer le brouillon ?"
- [ ] Créer `assets/admin/blocks-editor.scss` — styles de l'éditeur dans l'admin (toolbar, zone d'écriture, modal media)

**Fichiers créés :** `assets/admin/blocks-editor.js`, `assets/admin/blocks-editor.scss`

#### 4.5 Intégration EasyAdmin

- [ ] Créer `src/Controller/Admin/Api/MediaApiController.php` — `GET /admin/api/media/list` (liste des médias avec URL, filtrable)
- [ ] Créer `templates/admin/field/tiptap_editor.html.twig` — champ custom : `<div id="tiptap-editor">` + hidden input + charge les blocs existants via `window.existingBlocks`
- [ ] Modifier `ArticleCrudController.php` — remplacer `TextEditorField::new('content')` par champ custom blocks
- [ ] Modifier `PageCrudController.php` — idem
- [ ] Modifier `DashboardController.php` → `configureAssets()` : ajouter `build/admin_blocks.js` + `build/admin_blocks.css`
- [ ] Dashboard : ajouter stats (visites, top articles, graphique 30j Chart.js), raccourcis "Nouvel article" / "Nouvelle page", lien "Voir sur le site" par article

**Fichiers créés :** `MediaApiController.php`, `templates/admin/field/tiptap_editor.html.twig`
**Fichiers modifiés :** `ArticleCrudController.php`, `PageCrudController.php`, `DashboardController.php`, `templates/admin/dashboard.html.twig`

#### 4.6 Rendu front des blocs + CSS

- [ ] Créer `templates/_partials/tiptap_render.html.twig` — rend le JSON TipTap en HTML (ou utilise le cache `content`)
- [ ] Modifier `templates/article/show.html.twig` — utiliser `article.content|raw` (compilé depuis blocks par le listener)
- [ ] Modifier `templates/page/show.html.twig` — idem
- [ ] Créer `assets/css/base/blocks.scss` — styles des blocs côté front
  - `.block-image` (full/medium/small), `.block-video` (16:9 responsive), `.block-quote` (bordure primary), `.block-code` (fond sombre)
- [ ] Ajouter `loading="lazy"` sur toutes les images front (base, articles, widgets)

**Fichiers créés :** `tiptap_render.html.twig`, `blocks.scss`
**Fichiers modifiés :** `article/show.html.twig`, `page/show.html.twig`

#### 4.7 Notifications & Contact (Brevo)

- [ ] Câbler le formulaire de contact (`HomeController`) avec Brevo (envoi email au `site.email`)
- [ ] Notification nouvel article : dans `ArticleCrudController::persistEntity()`, si `published=true`, appeler `ArticleNotificationService` (async via Messenger)
- [ ] Widget subscribe amélioré : si user connecté, afficher toggle on/off abonnement au lieu de "Créer un compte"
- [ ] Masquer les liens sociaux dans le header/footer si non configurés dans `Site`

**Fichiers modifiés :** `HomeController.php`, `ArticleCrudController.php`, `templates/widgets/subscribe.html.twig`, `base.html.twig`

#### 4.8 UX Front

- [ ] Pagination articles : `ArticleRepository::findPublishedPaginated()` + `KnpPaginatorBundle` ou pagination manuelle
- [ ] Page résultats de recherche dédiée (remplacer le dropdown) avec highlighting du terme
- [ ] Breadcrumbs uniformes sur toutes les pages (article, page, catégorie, recherche)
- [ ] Articles connexes en fin d'article (3 articles de la même catégorie)
- [ ] Temps de lecture estimé (`ceil(str_word_count(content) / 200)` minutes)
- [ ] Boutons partage social (Facebook, X, LinkedIn, copier le lien) — liens statiques, pas de SDK
- [ ] Commentaires visibles directement (supprimer l'accordion)
- [ ] Archives widget dynamique (groupé par mois/année depuis les articles publiés)

**Fichiers modifiés :** `ArticleController.php`, `SearchController.php`, `ArticleRepository.php`, `article/show.html.twig`, `categorie/show.html.twig`, `widgets/archives.html.twig`, `widgets/subscribe.html.twig`
**Fichiers créés :** `templates/search/results.html.twig`

#### 4.9 UX Visuels & Mobile

- [ ] Animations hover cards articles (scale + shadow transition CSS)
- [ ] Transitions CSS sur les boutons (0.2s ease)
- [ ] Flash messages en toast Bootstrap auto-dismiss (3s)
- [ ] Breakpoint tablette 768px (optimiser le layout 2 colonnes)
- [ ] Tailles tactiles min 44x44px sur les boutons/liens mobiles
- [ ] Images responsives `srcset` sur les articles (si Media gère plusieurs tailles)

**Fichiers modifiés :** `assets/css/base/global.scss`, `article.scss`, `article_list.scss`, `header.scss`, `responsive/offcanvas-menu.scss`, `base.html.twig`

---

## Conventions de code

### Général
- PHP 8.4, typed properties, readonly, enums
- Symfony 7.4 LTS, attributs PHP 8 (`#[Route]`, `#[ORM\Entity]`, `#[Assert\...]`)
- PascalCase classes, camelCase méthodes/variables, snake_case BDD

### Architecture
- **Jamais** `->find(1)` → `SiteContext::getCurrentSite()`
- **Jamais** `findAll()` dans les controllers → méthodes Repository
- **Toujours** ownership check avant modif d'une ressource utilisateur
- **Toujours** `HtmlSanitizer` sur contenu rendu avec `|raw`

### Sécurité
- CSRF activé globalement
- `denyAccessUnlessGranted()` sur toute route sensible
- Password min 12 caractères, hash `auto`

### Front
- SCSS avec CSS custom properties (pas de couleurs hardcodées)
- Stimulus pour le JS interactif
- Bootstrap 5 personnalisé via custom properties

---

## Problèmes connus (issus de l'audit)

### Critiques — ✅ tous corrigés en Phase 1
- ~~Reset password sans token~~ → ✅ ResetPasswordBundle token-based
- ~~IDOR `/user/{id}/edit`~~ → ✅ ownership check + IsGranted
- ~~XSS via `|raw` sans sanitisation~~ → ✅ HtmlSanitizer Doctrine listener
- ~~Null pointer `ArticleController::show()`~~ → ✅ null guard + 404
- ~~CSRF commenté dans `framework.yaml`~~ → ✅ activé

### Importants — ✅ corrigés en Phase 1
- ~~Conflit PostgreSQL/MySQL~~ → ✅ MariaDB 11
- ~~`DataUserRepository` → entité inexistante~~ → ✅ supprimé
- ~~`CategorieRepository::findByArticle()` → DQL invalide~~ → ✅ corrigé (innerJoin)
- ~~`Categorie.featured_media` → SMALLINT~~ → ✅ vraie relation ManyToOne Media
- ~~Aucun index UNIQUE sur les slugs~~ → ✅ UNIQUE sur article/page/categorie/tag
- N+1 menus (base template) — à optimiser (eager loading)
- Contact form non câblé au mailer — à câbler avec Brevo
- Vérification email installée mais non activée

### Mineurs — ✅ corrigés en Phase 1
- ~~Typos : `caterogires.html.twig`~~ → ✅ renommé `categories.html.twig`
- ~~`mappedBy: 'User'` → `'user'`~~ → ✅ corrigé
- ~~Import container généré dans `ArticleCrudController`~~ → ✅ supprimé
- ~~Password min 6 → 12~~ → ✅ 12 chars (RegistrationFormType + PassType)
- Typos : `adress_1/2` — à corriger
- Archives widget hardcodé — à dynamiser
- Liens sociaux `href="#"` — à câbler

### En attente — sera traité en Phase 4
- ~~Migration `Version20260310051607`~~ → ✅ exécutée
- ⚠️ **Templates reset password** — à créer quand Brevo est configuré (Phase 4.7)
- ⚠️ **`docker-compose.prod.yml`** — pas encore créé
- ✅ **Null checks templates front** — corrigés
- Contact form non câblé → Phase 4.7
- Liens sociaux `href="#"` → Phase 4.7
- Archives widget hardcodé → Phase 4.8
- N+1 menus → à optimiser
- Typos `adress_1/2` → à corriger
- Abonnements `news`/`articles` sur User : stockés mais jamais utilisés → Phase 4.7

---

## Commandes utiles

### Docker

```bash
make up          # Lance tous les containers
make down        # Stop + supprime
make sh          # Shell PHP
make db          # Reset BDD : drop + create + migrate
make migrate     # Juste les migrations
make assets      # npm run dev
make assets-build # npm run build (prod)
make cc          # Cache clear
make logs        # Logs tous services
```

### Accès dev

| Service | URL |
|---------|-----|
| Application | http://localhost:8080 |
| Mailpit | http://localhost:8025 |
| MariaDB | localhost:3307 (app/app) |

### Installation nouveau client

Voir `SETUP.md` pour le process complet.

```bash
git clone git@repo:blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
cp .env.local.example .env.local    # Éditer BDD, APP_SECRET, MAILER_DSN (Brevo)
make up && make db && make assets
docker compose exec php php bin/console app:create-super-admin
docker compose exec php php bin/console app:init-site
# Se connecter /admin → personnaliser le site
```

---

## Structure cible (après Phase 4)

```
blog_web/
├── docker/
│   ├── php/Dockerfile
│   └── nginx/default.conf
├── assets/
│   ├── app.js                       # Entry front
│   ├── admin/
│   │   ├── blocks-editor.js         # Entry admin (TipTap)
│   │   └── blocks-editor.scss
│   └── css/base/
│       └── blocks.scss              # Styles blocs front
├── src/
│   ├── Entity/
│   │   ├── PageView.php             # Stats de visites
│   │   └── Trait/SeoTrait.php       # Module SEO
│   ├── Controller/
│   │   ├── Admin/Api/
│   │   │   └── MediaApiController.php
│   │   └── SitemapController.php
│   ├── EventSubscriber/
│   │   └── PageViewSubscriber.php   # Log visites front
│   ├── Service/
│   │   ├── SiteContext.php
│   │   ├── BlockRenderer.php        # JSON TipTap → HTML
│   │   └── ArticleNotificationService.php
│   └── Model/
│       └── TenantAwareInterface.php
├── templates/
│   ├── admin/field/
│   │   └── tiptap_editor.html.twig  # Champ custom EasyAdmin
│   ├── _partials/
│   │   └── tiptap_render.html.twig
│   └── search/
│       └── results.html.twig
└── ...
```

---

## Et après ? (voir CLAUDE_FULL.md)

Quand la demande le justifie :
- **Provisioning auto** → script `app:client:create` (gagne 25 min/installation)
- **Dashboard super-admin** → quand trop de clients pour un tableur
- **Agent IA (LintellO)** → quand l'outil est prêt
- **Abonnement Stripe** → quand la facturation manuelle ne suffit plus
- **Multi-tenant** → quand 30+ clients et besoin de mutualiser
