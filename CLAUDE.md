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

## Rôles & accès

### Hiérarchie des rôles

```
ROLE_USER < ROLE_AUTHOR < ROLE_ADMIN < ROLE_FREELANCE < ROLE_SUPER_ADMIN
```

| Rôle | Qui | Accès |
|------|-----|-------|
| `ROLE_USER` | Client final | Lecture, commentaires, profil |
| `ROLE_AUTHOR` | Rédacteur client | Création/édition articles et pages |
| `ROLE_ADMIN` | Admin client | Gestion complète du site (users, menus, médias) |
| `ROLE_FREELANCE` | Freelance revendeur | Idem SUPER_ADMIN sur ses propres sites uniquement |
| `ROLE_SUPER_ADMIN` | David | Accès total, tous les sites, config infrastructure |

### Modèle de distribution freelance

- David facture le freelance (abonnement mensuel plateforme)
- Le freelance gère sa relation client en totale autonomie
- La plateforme est invisible pour le client final (whitelabel implicite)
- Support disponible : formation optionnelle + ajout de fonctionnalités sur devis

### Implémentation technique ROLE_FREELANCE

- Ajouter `ROLE_FREELANCE` dans `RoleEnum.php`
- Ajouter dans `role_hierarchy` dans `security.yaml`
- Champ `owner` (FK `User`, nullable) sur l'entité `Site` → le freelance ne voit que ses sites
- Filtre Repository selon rôle connecté : `ROLE_FREELANCE` filtre par `site.owner = currentUser`, `ROLE_SUPER_ADMIN` voit tout
- Les actions réservées SUPER_ADMIN (config Docker, accès serveur) restent hors EasyAdmin

---

## Templates & Design

### Philosophie

3 à 4 templates de base intégrés dans le code. Le choix du template est réservé à `ROLE_SUPER_ADMIN` et `ROLE_FREELANCE`. Le client final ne choisit pas son design — il édite ses contenus et personnalise couleurs/logo uniquement.

Les sites sont montés et configurés visuellement par David ou le freelance via Claude Code. Pas d'interface de customisation visuelle complexe côté client.

### Sélection du template

Champ `template` (string, enum) sur l'entité `Site` :

```php
// Valeurs possibles
'default'     // Template standard blog/vitrine
'corporate'   // Template professionnel sobre
'portfolio'   // Template visuel orienté galerie
'landing'     // Template one-page conversion
```

Switch Twig dans `base.html.twig` :

```twig
{% set layout = site.template|default('default') %}
{% extends 'themes/' ~ layout ~ '/base.html.twig' %}
```

### Structure des templates

```
templates/
├── themes/
│   ├── default/
│   │   ├── base.html.twig
│   │   ├── home.html.twig
│   │   └── _partials/
│   ├── corporate/
│   ├── portfolio/
│   └── landing/
└── admin/          # Templates EasyAdmin (communs à tous les thèmes)
```

### Personnalisation par client (surcouche CSS)

Chaque template utilise les CSS custom properties — la personnalisation couleur/typo/logo s'applique à tous les thèmes sans modification de code :

```scss
// Dans chaque template SCSS
color: var(--primary);
font-family: var(--font-family);
background: var(--secondary);
```

Variables disponibles sur l'entité `Site` :
- `primaryColor` — couleur principale
- `secondaryColor` — couleur secondaire
- `accentColor` — couleur d'accent (à ajouter)
- `fontFamily` — police principale
- `fontFamilySecondary` — police titres (à ajouter)
- `logo` (FK Media) — logo header
- `favicon` (FK Media) — favicon

### Admin template (SUPER_ADMIN / FREELANCE uniquement)

Dans `SiteCrudController` :
```php
ChoiceField::new('template')
    ->setChoices(['Défaut' => 'default', 'Corporate' => 'corporate', ...])
    ->setPermission('ROLE_FREELANCE'),
ColorField::new('primaryColor')->setPermission('ROLE_FREELANCE'),
ColorField::new('secondaryColor')->setPermission('ROLE_FREELANCE'),
// ...
```

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
- [ ] `primaryColor`, `secondaryColor`, `accentColor`, `fontFamily`, `fontFamilySecondary` (personnalisation client)
- [ ] `template` (string enum : `default`, `corporate`, `portfolio`, `landing`) — sélection SUPER_ADMIN/FREELANCE uniquement
- [ ] `owner` (FK User nullable, ROLE_FREELANCE) — rattachement site à un freelance

#### 2.3 Rendu Twig

- [ ] Block `{% block seo %}` dans `base.html.twig` : `<title>`, `<meta description>`, `<meta keywords>`, `<link canonical>`, `<meta robots>`
- [ ] Open Graph : `og:title`, `og:description`, `og:image`, `og:url`, `og:type`
- [ ] Twitter Cards : `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`
- [ ] Schema.org JSON-LD : `Article`, `BreadcrumbList`
- [ ] Fallback : `seoTitle` → `title` → `site.defaultSeoTitle`
- [ ] Injection CSS custom properties depuis `Site` (couleurs, fonts)
- [ ] `robots.txt` dynamique via `RobotsController` (respect `noIndex` global du site)

#### 2.4 Sitemap XML

- [ ] `SitemapController` → route `/sitemap.xml`
- [ ] Articles + pages publiés + catégories avec `<lastmod>`, `<changefreq>`, `<priority>`

#### 2.5 Admin SEO

- [ ] Onglet "SEO" dans `ArticleCrudController`, `PageCrudController`, `CategorieCrudController`
- [ ] Compteurs de caractères (70 pour title, 160 pour description)
- [ ] Champs SEO + couleurs/fonts dans `SiteCrudController`

#### 2.6 Performance & Lighthouse

- [ ] **Conversion WebP automatique** à l'upload Media : `imagine/imagine` ou `intervention/image` — génère `.webp` + fallback `.jpg`
- [ ] **Lazy-loading natif** : `loading="lazy"` sur toutes les balises `<img>` hors above-the-fold (déjà partiellement fait en 4.6, à systématiser)
- [ ] **Cache HTTP Nginx** : headers `Cache-Control` pour assets statiques (1 an) et pages HTML (selon config)
- [ ] **Objectif Lighthouse** : score 95+ Performance, 100 SEO, 100 Accessibilité — à mesurer avant livraison client

---

### Phase 3 — Thème personnalisable (~1 jour)

#### 3.1 CSS custom properties ✅ (fait en Phase 5)

- [x] Modifier `assets/css/base/variables.scss` : remplacer `$bw-blue` etc. par `var(--primary)`, `var(--secondary)`, `var(--accent)`
- [x] Conserver les valeurs SCSS comme fallback pour le build
- [x] Vérifier que tous les composants utilisent les CSS custom properties

#### 3.2 Structure multi-templates

- [ ] Créer `templates/themes/default/` — déplacer les templates actuels
- [ ] Créer `templates/themes/corporate/` — template sobre, orienté services B2B
- [ ] Créer `templates/themes/portfolio/` — template visuel, galerie, créatifs
- [ ] Créer `templates/themes/landing/` — one-page, orienté conversion
- [ ] Switch Twig dans `base.html.twig` selon `site.template`
- [ ] Chaque thème hérite des partials communs (`_partials/`) pour éviter la duplication

#### 3.3 Personnalisation admin

- [ ] `SiteCrudController` : `ColorField` pour primaire/secondaire/accent, choix de fonts, logo, favicon
- [ ] `ChoiceField` pour `template` — visible uniquement `ROLE_FREELANCE` et `ROLE_SUPER_ADMIN`
- [ ] Le thème s'applique via les custom properties injectées dans `base.html.twig`

#### 3.4 Rôle FREELANCE

- [ ] Ajouter `ROLE_FREELANCE` dans `RoleEnum.php`
- [ ] Ajouter dans `role_hierarchy` dans `security.yaml` : `ROLE_FREELANCE: [ROLE_ADMIN]`
- [ ] Champ `owner` (FK User) sur `Site` + migration
- [ ] `SiteRepository::findByOwner(User $user)` — filtre par owner pour ROLE_FREELANCE
- [ ] `DashboardController` : si `ROLE_FREELANCE` sans `ROLE_SUPER_ADMIN`, filtrer les sites affichés
- [ ] `SiteCrudController` : restreindre les champs sensibles (template, couleurs) à `ROLE_FREELANCE+`

---

### Phase 4 — Éditeur TipTap + UX + Stats + Notifications ✅

#### 4.0 Nettoyage & simplification admin ✅

- [x] Supprimer stubs (`LikeCrudController`, `OptionCrudController`)
- [x] Nettoyer imports morts dans `MenuCrudController`
- [x] Corriger typos admin (`SiteCrudController`, labels)
- [x] Réorganiser `DashboardController::configureMenuItems()` (menu simplifié, rôles)
- [x] `ArticleCrudController` / `PageCrudController` : panels EasyAdmin (Contenu / Paramètres / Avancé)
- [x] `published_at` auto-rempli quand `published` passe à `true`

#### 4.1 Entités + Migration ✅

- [x] `Article.php` : `blocks` (JSON), `draftBlocks` (JSON), `published_at`, virtual `getBlocksJson()`/`setBlocksJson()`
- [x] `Page.php` : idem (blocks + virtual properties)
- [x] `PageView.php` : entité stats de visites (url, ipHash SHA-256, userAgent, referer, createdAt)
- [x] `PageViewRepository.php` : `countToday()`, `countThisWeek()`, `topArticles()`, `dailyStats()`
- [x] Migration exécutée

#### 4.2 Services backend ✅

- [x] `BlockRenderer.php` — JSON TipTap → HTML (text, image, video, quote, code, separator)
- [x] `ContentSanitizeListener.php` — compile blocks via BlockRenderer → cache dans `content`, null-safe
- [x] `PageViewSubscriber.php` — log requêtes front (exclut /admin, /_wdt, assets), IP hashée SHA-256
- [x] `ArticleNotificationService.php` — email Brevo aux abonnés quand article publié

#### 4.3 Webpack + dépendances npm ✅

- [x] `@tiptap/core`, `@tiptap/starter-kit`, `@tiptap/extension-image`, `@tiptap/extension-youtube`, `@tiptap/extension-placeholder`, `@tiptap/extension-typography`, `@tiptap/extension-link`
- [x] Entry Webpack `admin_editor` → `./assets/admin/tiptap-editor.js`

#### 4.4 Éditeur TipTap (JS + CSS admin) ✅

- [x] `assets/admin/tiptap-editor.js` (~520 lignes) — éditeur WYSIWYG complet
  - StarterKit + Image + YouTube + Placeholder + Typography + Link
  - Toolbar complète (gras, italique, titres, listes, citation, lien, image, vidéo, code, séparateur)
  - Modal bibliothèque Media (fetch `/admin/api/media/list`)
  - Autosave localStorage 30s + indicateur visuel + restauration brouillon
  - Protection doc vide (ne sauvegarde pas les blocs vides → préserve ancien contenu)
- [x] `assets/admin/tiptap-editor.scss` — styles admin (toolbar, éditeur, modal, ProseMirror)

#### 4.5 Intégration EasyAdmin ✅

- [x] `MediaApiController.php` — `GET /admin/api/media/list` (`#[IsGranted('ROLE_AUTHOR')]`)
- [x] `ArticleCrudController` / `PageCrudController` — `TextareaField('blocksJson')` avec `data-tiptap-editor`
- [x] `DashboardController::configureAssets()` — entry `admin_editor`
- [x] Notifications câblées dans `persistEntity()` / `updateEntity()` via `ArticleNotificationService`

#### 4.6 Rendu front des blocs + CSS ✅

- [x] `assets/css/base/blocks.scss` — styles front (content, images, vidéo, quote, code, share buttons, related articles)
- [x] `loading="lazy"` sur toutes les images (article show, page show, article_liste_large)
- [x] Import dans `main.scss`

#### 4.7 Notifications & Contact (Brevo) ✅

- [x] `ContactType.php` — formulaire Symfony avec validation
- [x] `HomeController::contact()` — câblé avec `MailerInterface` + `SiteContext` (envoi au `site.email`)
- [x] `contact.html.twig` — utilise `{{ form_widget(contactForm) }}` au lieu du HTML statique
- [x] `ArticleCrudController` — appelle `ArticleNotificationService::notifySubscribers()` à la publication
- [x] `subscribe.html.twig` — auth-aware (profil si connecté, inscription sinon)
- [x] Brevo SMTP configuré dans `.env.local` (`brevo+smtp://`)
- [x] `.env` — défaut Mailpit pour dev, `.env.local.example` — template Brevo pour clients

#### 4.8 UX Front ✅

- [x] Pagination articles — `findPublishedPaginated()` avec Doctrine Paginator + template Bootstrap
- [x] Filtre archives par mois/année — plage de dates DQL dans `findPublishedPaginated(month, year)`
- [x] `show_all.html.twig` — refonte complète (layout responsive, pagination, filtre archive, breadcrumbs)
- [x] Articles connexes — `findRelated()` (même catégorie, exclut courant)
- [x] Temps de lecture — filtre Twig `readingTime` (200 mots/min)
- [x] Boutons partage social — Facebook, Twitter, LinkedIn, copier le lien (statique, pas de SDK)
- [x] Commentaires visibles directement (accordion supprimé)
- [x] Archives widget dynamique — `findArchiveMonths()` (SQL natif GROUP BY mois/année)
- [x] Flash messages — alerts Bootstrap dismissible (au lieu de toast-body)
- [x] Breadcrumbs uniformes sur article, page, blog
- [x] Lien Contact footer câblé

#### 4.9 UX Visuels & Mobile — partiellement fait (Phase 5)

- [x] Animations hover cards articles (scale + shadow transition CSS) → fait en Phase 5
- [x] Transitions CSS sur les boutons (0.2s ease) → fait en Phase 5
- [x] Breakpoint tablette 768px (optimiser le layout 2 colonnes) → fait en Phase 5
- [x] Tailles tactiles min 44x44px sur les boutons/liens mobiles → fait en Phase 5
- [ ] Images responsives `srcset` sur les articles (si Media gère plusieurs tailles)
- [ ] Page résultats de recherche dédiée (remplacer le dropdown) avec highlighting du terme

---

### Phase 5 — Refonte Design & CSS ✅

> Refonte complète du thème par défaut : design moderne, coloré, inspiré SaaS (référence : lintello.fr).

#### 5.1 Design Tokens & Variables ✅

- [x] `assets/css/base/variables.scss` — palette complète : `#2563EB` primary, `#F59E0B` secondary, `#8B5CF6` accent
- [x] CSS custom properties dans `:root` (couleurs, shadows 4 niveaux, radius, transitions)
- [x] Typographie unifiée : Inter (display + body) + JetBrains Mono (code)
- [x] Mixins sans `!important` : `title-one`, `title-two`, `link-menu`, `btn-font`
- [x] `_variables-custom.scss` — overrides Bootstrap 5 (couleurs, typo, radius, buttons, inputs, cards)

#### 5.2 Header ✅

- [x] `header.scss` — sticky header avec `backdrop-filter: blur(12px)`, border-bottom subtile
- [x] Logo contraint à 42px desktop / 36px mobile (plus de logo géant)
- [x] Nav links `font-weight: 600`, padding `0.5rem 1rem`, hover primary-light
- [x] Admin bar sombre, search input avec transition width
- [x] Mobile : offcanvas Bootstrap, hamburger 44px touch target

#### 5.3 Homepage ✅

- [x] `home.scss` + `home/index.html.twig` — refonte complète
- [x] **Hero** : gradient bleu→violet, cercles décoratifs, badge "CMS professionnel"
  - 2 boutons visibles : btn-light (blanc) + btn-outline-light (bordure)
  - 3 badges de confiance (Installation 30 min, RGPD, Hébergé en France)
- [x] **Features** : grille 3 colonnes (responsive 2→1), 6 cards avec icônes SVG inline
  - Éditeur, Pages & Layouts, Navigation, SEO, Contact & Notifications, Design personnalisable
- [x] **Metrics** : bande de chiffres clés (30 min, 100%, 0, 1) avec border top/bottom
- [x] **CTA final** : section gradient "Prêt à lancer votre site ?" avec bouton contact
- [x] Team section nettoyée (texte raccourci, layout amélioré)

#### 5.4 Footer ✅

- [x] `footer.scss` + `base.html.twig` — refonte complète
- [x] Logo 40px max, tagline descriptive
- [x] 3 colonnes : Logo+social | Navigation | Informations légales
- [x] Recherche supprimée du footer
- [x] Icônes sociales en carrés arrondis avec fond semi-transparent
- [x] Copyright dynamique `{{ "now"|date("Y") }}`
- [x] Gradient accent line en haut du footer

#### 5.5 Composants globaux ✅

- [x] `global.scss` — `.btn-gradient`, dropdowns modernes, breadcrumbs, form controls focus ring
- [x] `article.scss` — article detail avec `clamp()` titre, category badges pills, comments cards
- [x] `article_list.scss` — blog listing cards avec hover translateY + shadow
- [x] `blocks.scss` — tokens CSS custom properties (plus de couleurs hardcodées)
- [x] `widgets.scss` — cards avec border/radius/shadow, subscribe gradient
- [x] `contact.scss` — contact info en surface cards
- [x] `page.scss` — featured image avec titre overlay gradient
- [x] `offcanevas-menu.scss` — mobile nav avec border-bottom items
- [x] `forms_log.scss` — login/register en card centrée
- [x] `user_info.scss` — profil utilisateur card

#### 5.6 Isolation CSS EasyAdmin ✅

- [x] Supprimé `addCssFile('build/app.css')` dans `DashboardController::configureAssets()`
- [x] Les styles front ne débordent plus sur l'admin (boutons, liens, form-controls)
- [x] EasyAdmin utilise ses propres styles natifs, seuls `admin_editor` et `admin_menu` sont injectés

**Fichier modifié :** `DashboardController.php`

#### 5.7 À affiner (prochaine passe)

- [ ] Affiner les couleurs (nuances primary/secondary/accent)
- [ ] Ajuster les marges/paddings sur certaines sections
- [ ] Vérifier le rendu sur toutes les pages (article detail, page, catégories, recherche)

**Fichiers SCSS modifiés (16) :** `variables.scss`, `_variables-custom.scss`, `app.scss`, `main.scss`, `global.scss`, `header.scss`, `home.scss`, `footer.scss`, `article.scss`, `article_list.scss`, `blocks.scss`, `widgets.scss`, `contact.scss`, `page.scss`, `offcanevas-menu.scss`, `forms_log.scss`, `user_info.scss`
**Fichiers Twig modifiés (2) :** `base.html.twig`, `home/index.html.twig`

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
- **Toujours** vérifier `site.owner` pour les actions ROLE_FREELANCE

### Sécurité
- CSRF activé globalement
- `denyAccessUnlessGranted()` sur toute route sensible
- Password min 12 caractères, hash `auto`

### Front
- SCSS avec CSS custom properties (pas de couleurs hardcodées)
- Stimulus pour le JS interactif
- Bootstrap 5 personnalisé via custom properties
- `loading="lazy"` systématique sur les images

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
- ~~Contact form non câblé au mailer~~ → ✅ câblé avec Brevo (Phase 4.7)
- N+1 menus (base template) — à optimiser (eager loading)
- Vérification email installée mais non activée

### Mineurs — ✅ corrigés en Phase 1
- ~~Typos : `caterogires.html.twig`~~ → ✅ renommé `categories.html.twig`
- ~~`mappedBy: 'User'` → `'user'`~~ → ✅ corrigé
- ~~Import container généré dans `ArticleCrudController`~~ → ✅ supprimé
- ~~Password min 6 → 12~~ → ✅ 12 chars (RegistrationFormType + PassType)
- ~~Archives widget hardcodé~~ → ✅ dynamisé (Phase 4.8)
- ~~Liens sociaux `href="#"`~~ → ✅ câblés dans le footer (Phase 5)
- Typos : `adress_1/2` — à corriger

### En attente
- ~~Migration `Version20260310051607`~~ → ✅ exécutée
- ~~Contact form non câblé~~ → ✅ fait (Phase 4.7)
- ~~Liens sociaux `href="#"`~~ → ✅ câblés (Phase 5)
- ~~Archives widget hardcodé~~ → ✅ dynamisé (Phase 4.8)
- ~~Null checks templates front~~ → ✅ corrigés
- ⚠️ **`docker-compose.prod.yml`** — pas encore créé
- N+1 menus → à optimiser (eager loading)
- Typos `adress_1/2` → à corriger
- Abonnements `news`/`articles` sur User : stockés mais jamais utilisés
- Vérification email installée mais non activée

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
# Se connecter /admin → personnaliser le site (template, couleurs, logo)
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
│       ├── blocks.scss              # Styles blocs front
│       └── variables.scss           # CSS custom properties
├── src/
│   ├── Entity/
│   │   ├── PageView.php             # Stats de visites
│   │   └── Trait/SeoTrait.php       # Module SEO
│   ├── Controller/
│   │   ├── Admin/Api/
│   │   │   └── MediaApiController.php
│   │   ├── SitemapController.php
│   │   └── RobotsController.php     # robots.txt dynamique
│   ├── EventSubscriber/
│   │   └── PageViewSubscriber.php   # Log visites front
│   ├── Service/
│   │   ├── SiteContext.php
│   │   ├── BlockRenderer.php        # JSON TipTap → HTML
│   │   └── ArticleNotificationService.php
│   └── Model/
│       └── TenantAwareInterface.php
├── templates/
│   ├── themes/
│   │   ├── default/                 # Template standard (blog/vitrine)
│   │   │   ├── base.html.twig
│   │   │   └── home.html.twig
│   │   ├── corporate/               # Template sobre B2B
│   │   ├── portfolio/               # Template visuel/galerie
│   │   └── landing/                 # One-page conversion
│   ├── _partials/                   # Partials communs à tous les thèmes
│   │   └── tiptap_render.html.twig
│   ├── admin/field/
│   │   └── tiptap_editor.html.twig  # Champ custom EasyAdmin
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
