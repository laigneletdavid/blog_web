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
- `primaryColor` — couleur principale (default '#2563EB')
- `secondaryColor` — couleur secondaire (default '#F59E0B')
- `accentColor` — couleur d'accent (default '#8B5CF6')
- `fontFamily` — police principale (default "'Inter', sans-serif")
- `fontFamilySecondary` — police titres (nullable)
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

### Phase 2 — Module SEO ✅

#### 2.1 SeoTrait ✅

- [x] Créer `src/Entity/Trait/SeoTrait.php` : `seoTitle(70)`, `seoDescription(160)`, `seoKeywords(255)`, `noIndex(bool)`, `canonicalUrl(255)` — avec `Assert\Length` et `Assert\Url`
- [x] Appliquer sur `Article`, `Page`, `Categorie` via `use SeoTrait;`
- [x] Migration Doctrine

#### 2.2 Champs SEO + thème sur Site ✅

- [x] `defaultSeoTitle`, `defaultSeoDescription`, `googleAnalyticsId`, `googleSearchConsole`, `favicon` (FK Media)
- [x] `primaryColor` (default '#2563EB'), `secondaryColor` (default '#F59E0B'), `accentColor` (default '#8B5CF6'), `fontFamily` (default "'Inter', sans-serif"), `fontFamilySecondary` (nullable)
- [x] `template` (string enum : `default`, `corporate`, `portfolio`, `landing`) — sélection SUPER_ADMIN/FREELANCE uniquement
- [x] `owner` (FK User nullable, ROLE_FREELANCE) — rattachement site à un freelance
- [x] `ROLE_FREELANCE` ajouté dans `RoleEnum.php` + `role_hierarchy` dans `security.yaml`

#### 2.3 Rendu Twig ✅

- [x] Block `{% block seo %}` dans `base.html.twig` : `<title>`, `<meta description>`, `<meta keywords>`, `<link canonical>`, `<meta robots>`
- [x] Open Graph : `og:title`, `og:description`, `og:image`, `og:url`, `og:type`, `og:site_name`, `og:locale`
- [x] Twitter Cards : `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`
- [x] Schema.org JSON-LD : `Article` + `BreadcrumbList` (article, page, categorie)
- [x] Fallback chain : `seoTitle` → `title` → `site.defaultSeoTitle` → `site.name`
- [x] Injection CSS custom properties depuis `Site` (--primary, --secondary, --accent, --font-family, --font-family-secondary)
- [x] `robots.txt` dynamique via `RobotsController` (Disallow /admin/, /login, /register + Sitemap link)
- [x] Google Analytics conditionnel + Google Search Console verification meta
- [x] Favicon dynamique depuis `Site.favicon` avec fallback statique
- [x] `<meta name="viewport">` ajouté (manquait)

#### 2.4 Sitemap XML ✅

- [x] `SitemapController` → route `/sitemap.xml`
- [x] Articles (0.8) + pages (0.6) + catégories (0.5) + home (1.0) + blog (0.7) + contact (0.4)
- [x] `<lastmod>`, `<changefreq>`, `<priority>` — filtre `noIndex=false` et `published=true`
- [x] `findAllPublishedForSitemap()` dans `ArticleRepository` et `PageRepository`

#### 2.5 Admin SEO ✅

- [x] Panel "SEO" collapsible (renderCollapsed) dans `ArticleCrudController`, `PageCrudController`, `CategorieCrudController`
- [x] 5 champs par entité : seoTitle (maxlength 70), seoDescription (maxlength 160, rows 3), seoKeywords, noIndex, canonicalUrl
- [x] Help texts explicatifs sur chaque champ (intérêt SEO, cas d'usage)
- [x] `SiteCrudController` : 4 panels — Identité, SEO, Apparence (ROLE_FREELANCE), Propriété (ROLE_SUPER_ADMIN)
- [x] `MediaCrudController` : panel Fichier avec name (alt text + placeholder), image (help formats), webpFileName en index

#### 2.6 Performance & Lighthouse ✅

- [x] **Conversion WebP automatique** : `MediaUploadListener` (postPersist/postUpdate) via `intervention/image` v3 — génère `.webp` qualité 85 à côté de l'original
- [x] **Champ `webpFileName`** sur `Media` pour stocker le nom du fichier WebP
- [x] **Lazy-loading natif** : `loading="lazy"` systématique (déjà fait en Phase 4.6)
- [x] **Cache HTTP Nginx** : `Cache-Control: public, immutable` 1 an sur assets statiques (js, css, images, webp) + security headers (X-Content-Type-Options, X-Frame-Options, X-XSS-Protection, Referrer-Policy)

**SeoService** (`src/Service/SeoService.php`) :
- `resolve(object $entity): array` — résout titre/description/image/type avec fallback chain
- `resolveForHome(): array` — SEO page d'accueil
- `resolveForPage(string $pageTitle): array` — SEO pages génériques (contact, etc.)
- `getCurrentSite(): ?Site` — proxy Twig global (`seo_service` dans `twig.yaml`)

**Fichiers créés (7) :** `SeoTrait.php`, `SeoService.php`, `SitemapController.php`, `RobotsController.php`, `MediaUploadListener.php`, `sitemap/index.xml.twig`, `robots/index.txt.twig`
**Fichiers modifiés (18) :** `Article.php`, `Page.php`, `Categorie.php`, `Site.php`, `Media.php`, `RoleEnum.php`, `security.yaml`, `twig.yaml`, `services.yaml`, `base.html.twig`, `article/show.html.twig`, `page/show.html.twig`, `categorie/show.html.twig`, `HomeController.php`, `ArticleController.php`, `PageController.php`, `CategorieController.php`, `nginx/default.conf`
**Fichiers admin modifiés (4) :** `ArticleCrudController.php`, `PageCrudController.php`, `CategorieCrudController.php`, `SiteCrudController.php`, `MediaCrudController.php`
**Repositories modifiés (2) :** `ArticleRepository.php`, `PageRepository.php`

---

### Phase 3 — Systeme Multi-Themes ✅

> Approche B : un seul `base.html.twig` (SEO, head, scripts) qui inclut dynamiquement header/footer depuis le theme actif. Les pages de contenu restent inchangees.

#### 3.0 Prealables ✅ (faits en Phase 2 et 5)

- [x] CSS custom properties dans `variables.scss` : `var(--primary)`, `var(--secondary)`, `var(--accent)`
- [x] `SiteCrudController` : `ColorField` pour primaire/secondaire/accent, choix de fonts, logo, favicon
- [x] `ChoiceField` pour `template` — visible uniquement `ROLE_FREELANCE` et `ROLE_SUPER_ADMIN`
- [x] Custom properties injectées dans `base.html.twig` depuis `Site`
- [x] `ROLE_FREELANCE` dans `RoleEnum.php` + `security.yaml`
- [x] Champ `owner` (FK User) sur `Site`
- [x] `SiteCrudController` : champs sensibles restreints à `ROLE_FREELANCE+`

#### 3.1 Variables CSS du système (13 variables) ✅

**Sur Site (personnalisables par client dans admin) — 5 :** `--primary`, `--secondary`, `--accent`, `--font-family`, `--font-family-secondary`

**Dans theme.yaml uniquement (fixées par thème) — 6 :** `--bg` (fond), `--surface` (cards), `--border` (séparateurs), `--text` (texte principal), `--text-muted` (texte secondaire), `--radius` (border-radius)

**Meta-config YAML (non CSS, influencent le HTML) — 2 :** `buttonStyle` (filled/outline/gradient/pill), `headerStyle` (sticky-white/sticky-transparent/static)

#### 3.2 ThemeService ✅

- [x] Créer `src/Service/ThemeService.php` — scanne `templates/themes/*/theme.yaml`, cache 1h
  - `getAvailableThemes()`, `getTheme()`, `getDefaults()`, `getThemeVars()`, `getConfig()`, `hasTemplate()`, `clearCache()`
  - `resolveAppearance()` — résout couleurs/polices avec fallback chain : site → theme → hardcoded
  - `resolveAppearanceForTheme()` — pure defaults du thème (pour preview)
- [x] `config/services.yaml` — bind `$projectDir`
- [x] `config/packages/twig.yaml` — global `theme_service`

#### 3.3 Theme default : extraction ✅

- [x] Créer `templates/themes/default/theme.yaml` — config avec defaults actuels
- [x] Extraire header de `base.html.twig` → `templates/themes/default/_header.html.twig`
- [x] Extraire footer de `base.html.twig` → `templates/themes/default/_footer.html.twig`
- [x] Extraire body de `home/index.html.twig` → `templates/themes/default/home.html.twig`
- [x] Extraire body de `article/show_all.html.twig` → `templates/themes/default/blog.html.twig`

#### 3.4 Intégration Twig ✅

- [x] `base.html.twig` : remplacer header/footer inline par `{% include ['themes/' ~ _theme ~ '/...', 'themes/default/...'] %}`
- [x] `base.html.twig` : injecter theme_vars CSS (--bg, --surface, --text, etc.) dans `:root`
- [x] `base.html.twig` : Google Fonts dynamique depuis `_theme_config.google_fonts`
- [x] `base.html.twig` : charger `theme.css` conditionnel si présent
- [x] `base.html.twig` : preview mode (`?_preview_theme=slug`) avec réécriture des liens internes
- [x] `home/index.html.twig` : transformer en dispatcher theme
- [x] `article/show_all.html.twig` : transformer en dispatcher theme (blog)

#### 3.5 Admin Theme Browser ✅

- [x] `DashboardController` : route `GET /admin/theme-browser` (`ROLE_FREELANCE+`) — page navigation themes
- [x] `DashboardController` : route `POST /admin/theme-activate/{slug}` (`ROLE_FREELANCE+`) — activation (CSRF protégé)
- [x] `DashboardController` : route `GET /admin/theme-preview/{slug}` (`ROLE_FREELANCE+`) — sert preview.png
- [x] `DashboardController` : route `GET /theme-css/{slug}` — sert theme.css (accessible front, cache 1h)
- [x] `DashboardController::configureMenuItems()` : section "Apparence" (`ROLE_FREELANCE+`) avec Catalogue, Réglages, Images
- [x] Créer `templates/admin/themes/browser.html.twig` — grille cards avec preview, couleurs, bouton activer, preview fullscreen (iframe responsive desktop/tablette/mobile)

#### 3.6 Créer les 5 themes ✅

- [x] `corporate` — PME services B2B, sobre et professionnel (Montserrat)
- [x] `artisan` — Commerce local, chaleureux (Lato)
- [x] `vitrine` — Site vitrine élégant, professions libérales (DM Sans)
- [x] `starter` — Minimaliste, point de départ (Inter)
- [x] `moderne` — Design contemporain dark mode, animations (Space Grotesk)

Chaque theme : `theme.yaml` + `_header.html.twig` + `_footer.html.twig` + `home.html.twig` + `blog.html.twig` + `contact.html.twig` + `theme.css` + `preview.png`

#### 3.7 Admin Apparence (ThemeSettings + ThemeImages) ✅

- [x] `ThemeSettingsCrudController` (`ROLE_FREELANCE+`) — couleurs, polices, images hero/about avec overlay null = theme default
- [x] `ThemeImagesCrudController` (`ROLE_FREELANCE+`) — galerie d'images du thème (`SiteGalleryItem`)
- [x] `FontService` — 20 Google Fonts avec choix primary/secondary
- [x] Surcouche CSS : valeur null = default du thème, valeur non-null = override client

#### 3.8 ROLE_FREELANCE ✅

- [x] `SiteRepository::findByOwner(User $user)` — filtre par owner pour ROLE_FREELANCE
- [x] Routes theme : `#[IsGranted('ROLE_FREELANCE')]` sur browser, activate, preview
- [x] Menu "Apparence" : `$this->isGranted('ROLE_FREELANCE')` — invisible pour ROLE_ADMIN
- [x] `ThemeSettingsCrudController` + `ThemeImagesCrudController` : `#[IsGranted('ROLE_FREELANCE')]` sur la classe
- [x] Filtrage multi-site préparé (`findByOwner`) — activable en multi-tenant

#### 3.9 Placeholder images + fixes ✅

- [x] Fallback `asset('images/placeholder.jpg')` sur tous les templates (hero, about, contact) via ternaire Twig
- [x] Fix `article.categorie` → `article.categories` (Collection) dans tous les blog templates
- [x] Fix menu offcanvas mobile : fond blanc opaque, pas de scroll (`offcanevas-menu.scss`)

**Répartition :** Dev (par thème) = header, footer, home, blog, contact, theme.css, theme.yaml | Commun = SEO, article/show, page/show, formulaires, admin, scripts | Client = contenu TipTap, couleurs/polices via Admin Apparence

**Fichiers système créés (12) :** `ThemeService.php`, `FontService.php`, `ThemeSettingsCrudController.php`, `ThemeImagesCrudController.php`, `admin/themes/browser.html.twig`, + 6 `theme.yaml` (default, corporate, artisan, vitrine, starter, moderne)
**Fichiers par thème (6×7=42) :** `_header.html.twig`, `_footer.html.twig`, `home.html.twig`, `blog.html.twig`, `contact.html.twig`, `theme.css`, `preview.png`
**Fichiers modifiés (7) :** `base.html.twig`, `home/index.html.twig`, `article/show_all.html.twig`, `DashboardController.php`, `twig.yaml`, `services.yaml`, `offcanevas-menu.scss`
**Aucune migration** — `Site.template` existe déjà, theme_vars restent dans theme.yaml

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

#### 4.9 UX Visuels & Mobile ✅

- [x] Animations hover cards articles (scale + shadow transition CSS) → fait en Phase 5
- [x] Transitions CSS sur les boutons (0.2s ease) → fait en Phase 5
- [x] Breakpoint tablette 768px (optimiser le layout 2 colonnes) → fait en Phase 5
- [x] Tailles tactiles min 44x44px sur les boutons/liens mobiles → fait en Phase 5
- [x] **Images responsives `srcset`** sur les articles — génération auto de 3 tailles WebP (480w, 800w, 1200w) à l'upload
- [x] **Page résultats de recherche dédiée** — route `/recherche`, pagination, highlighting du terme, progressive enhancement

#### 4.10 Images responsives (srcset) ✅

- [x] `MediaUploadListener` : génère 3 variantes WebP (480w, 800w, 1200w) par convention de nommage (`{basename}-{width}w.webp`)
- [x] `ResponsiveImageExtension` : fonction Twig `responsive_img(media, sizes, class, alt)` → `<img srcset="..." sizes="..." loading="lazy">`
- [x] `BlockRenderer` : ajout automatique de `srcset`/`sizes` sur les images TipTap locales
- [x] Templates mis à jour : `article/show.html.twig`, `article/item.html.twig`, `article/article_liste_large.html.twig`

**Fichiers créés :** `ResponsiveImageExtension.php`
**Fichiers modifiés :** `MediaUploadListener.php`, `BlockRenderer.php`, `services.yaml`, `article/show.html.twig`, `article/item.html.twig`, `article/article_liste_large.html.twig`

#### 4.11 Page de recherche dédiée ✅

- [x] `SearchController::results()` — route `GET /recherche` avec pagination Doctrine, recherche articles/pages/catégories
- [x] Réponse JSON enrichie avec `seeAllUrl` pour le lien dropdown → page complète
- [x] Filtre Twig `|highlight(keyword)` — entoure les termes de `<mark>`, XSS-safe (htmlspecialchars avant insertion)
- [x] `templates/search/results.html.twig` — breadcrumbs, sections catégories/pages/articles, pagination, état "aucun résultat"
- [x] `assets/css/base/search.scss` — styles cards, badges type, thumbnails, `<mark>` highlighting
- [x] `search_controller.js` — cleanup (supprimé import mort `easingEffects`, méthode dupliquée `dosSearchdetail`), ajout lien "Voir tous les résultats →"
- [x] Progressive enhancement : form action → `/recherche` (HTML, fonctionne sans JS), `data-api-url` pour le dropdown AJAX

**Fichiers créés :** `templates/search/results.html.twig`, `assets/css/base/search.scss`
**Fichiers modifiés :** `SearchController.php`, `AppExtension.php`, `search_controller.js`, `main.scss`, `themes/default/_header.html.twig`

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
- ~~Images responsives srcset~~ → ✅ fait (Phase 4.10)
- ~~Page recherche dédiée~~ → ✅ fait (Phase 4.11)
- ⚠️ **`docker-compose.prod.yml`** — pas encore créé
- N+1 menus → à optimiser (eager loading)
- Typos `adress_1/2` → à corriger
- Abonnements `news`/`articles` sur User : stockés mais jamais utilisés
- Vérification email installée mais non activée
- Régénérer les images existantes avec `app:media:regenerate-sizes` (commande à créer si besoin)

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
