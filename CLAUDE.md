# Blog & Web — CMS MVP

## Objectif

CMS Symfony prêt à vendre. Un site propre, sécurisé, avec SEO intégré, clonable en 30 minutes pour chaque nouveau client. On vend du service (installation + personnalisation), pas du SaaS.

> Le plan complet (provisioning auto, dashboard super-admin, abonnements, IA) est dans `CLAUDE_FULL.md` — à dérouler plus tard si la demande est là.

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS (migration depuis PHP 8.1 / Symfony 6.1)
- **ORM** : Doctrine ORM + Migrations
- **Admin** : EasyAdmin Bundle 4.x
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Stimulus/Hotwire
- **Templates** : Twig 3
- **BDD** : MariaDB 11
- **Infra** : Docker (PHP-FPM 8.4 + Nginx + MariaDB 11 + Mailpit)

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

## Plan d'action MVP (~7-8 jours)

### Phase 1 — Docker + Upgrade + Sécurité + Nettoyage (~4 jours)

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

- [ ] Créer `docker/php/Dockerfile` — PHP 8.4-FPM + extensions (pdo_mysql, intl, gd, zip, opcache, apcu)
- [ ] Créer `docker/nginx/default.conf` — Config Nginx Symfony
- [ ] Réécrire `docker-compose.yml` — Tous les services
- [ ] Créer `docker-compose.override.yml` — Dev (ports, xdebug, mailpit)
- [ ] Créer `docker-compose.prod.yml` — Prod (opcache max, restart always)
- [ ] Créer `Makefile` — `make up`, `make down`, `make sh`, `make db`, `make cc`, `make assets`
- [ ] Créer `.dockerignore`
- [ ] Créer `.env.local.example` — Template pour chaque client
- [ ] Configurer `DATABASE_URL=mysql://app:app@db:3306/blog_web`
- [ ] Configurer `doctrine.yaml` → `server_version: 'mariadb-11.0'`

**Fichiers :**
- Nouveau : `docker/php/Dockerfile`, `docker/nginx/default.conf`
- Réécrit : `docker-compose.yml`, `docker-compose.override.yml`
- Nouveau : `docker-compose.prod.yml`, `Makefile`, `.dockerignore`, `.env.local.example`

#### 1.2 Upgrade PHP 8.4 + Symfony 7.4 LTS

- [ ] `composer.json` : `php >= 8.4`, `symfony/* 7.4.*`
- [ ] `composer update` dans le container PHP
- [ ] Adapter les deprecations Symfony 7 (security, routing, forms)
- [ ] Mettre à jour EasyAdmin compatible Symfony 7
- [ ] Mettre à jour `package.json` + `npm install`
- [ ] Tester le build Webpack Encore

**Fichiers :** `composer.json`, `composer.lock`, `symfony.lock`, `package.json`, `package-lock.json`, `config/packages/security.yaml`, `config/bundles.php`

#### 1.3 Failles de sécurité critiques

- [ ] **Reset password** : flow token-based avec `VerifyEmailBundle`. Supprimer `/find`
- [ ] **IDOR profil** : ownership check dans `UserController::edit()` et `editPass()`
- [ ] **XSS** : `HtmlSanitizer` sur contenu article/page avant persistance
- [ ] **Null checks** : guard avant `$article->getSlug()` + null check `PageController`
- [ ] **CSRF** : décommenter `csrf_protection: true` dans `framework.yaml`
- [ ] **Comment auth** : `denyAccessUnlessGranted('ROLE_USER')` sur bloc commentaire
- [ ] **Admin password** : surcharger `updateEntity()` dans `UserCrudController`

**Fichiers :** `HomeController`, `UserController`, `ArticleController`, `PageController`, `UserCrudController`, `framework.yaml`

#### 1.4 Nettoyage code mort

- [ ] Supprimer `DataUserRepository.php`, `User1Type.php`
- [ ] Supprimer import `ContainerCxexD47` dans `ArticleCrudController`
- [ ] Supprimer/finaliser stubs (`CommentController`, `TagController`)
- [ ] Supprimer méthode morte `DashboardController::url()`
- [ ] Nettoyer templates stub (`site/`, `tag/`, `media/index.html.twig`)
- [ ] Corriger typo `caterogires.html.twig` → `categories.html.twig`
- [ ] Corriger `mappedBy: 'User'` → `'user'` dans `User.php`
- [ ] Supprimer boucle morte `CategorieController::show()`
- [ ] Corriger `CategorieRepository::findByArticle()` (DQL invalide)
- [ ] Déplacer `phpdocumentor` et `phpstan` en `require-dev`

#### 1.5 Conventions future-proof

- [ ] Créer `src/Service/SiteContext.php` — `getCurrentSite()` retourne `find(1)` pour l'instant
- [ ] Remplacer tous les `->find('1')` / `->find(1)` par `SiteContext`
- [ ] Créer `src/Model/TenantAwareInterface.php` (interface vide, préparation)
- [ ] Vérifier que toutes les requêtes passent par les repositories

**Fichiers :** Nouveau `SiteContext.php`, `TenantAwareInterface.php`. Modifié `DashboardController`

#### 1.6 Corrections fonctionnelles

- [ ] `AppExtension::menuLink()` : gérer les menus sans lien (return `'#'`)
- [ ] Null check sur `widget_service.findLastArticle` dans `base.html.twig`
- [ ] `Categorie.featured_media` : SMALLINT → vraie relation ManyToOne Media
- [ ] Index UNIQUE sur `article.slug`, `page.slug`, `categorie.slug`, `tag.slug`
- [ ] Index sur `article.published`, `menu.is_visible`
- [ ] Password min → 12 caractères

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

### Critiques (Phase 1)
- Reset password sans token — n'importe qui peut changer n'importe quel MDP
- IDOR `/user/{id}/edit` — pas d'ownership check
- XSS via `|raw` sans sanitisation
- Null pointer `ArticleController::show()` avant null check
- CSRF commenté dans `framework.yaml`

### Importants (Phase 1)
- Conflit PostgreSQL/MySQL → résolu : MariaDB 11
- `DataUserRepository` → entité inexistante (supprimer)
- `CategorieRepository::findByArticle()` → DQL invalide
- `Categorie.featured_media` → SMALLINT au lieu de relation
- N+1 menus (base template) et `CategorieController`
- Aucun index UNIQUE sur les slugs
- Contact form non câblé au mailer
- Vérification email installée mais non activée

### Mineurs (Phase 1)
- Typos : `adress_1/2`, `caterogires.html.twig`
- `mappedBy: 'User'` → `'user'`
- Import container généré dans `ArticleCrudController`
- Password min 6 → 12
- Archives widget hardcodé
- Liens sociaux `href="#"`

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
| MariaDB | localhost:3306 (app/app) |

### Installation nouveau client

```bash
git clone git@repo:blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
cp .env.local.example .env.local    # Éditer BDD, APP_SECRET, domaine
make up && make db
# Se connecter /admin → personnaliser le site
```

---

## Structure cible (après MVP)

```
blog_web/
├── docker/
│   ├── php/Dockerfile              # PHP 8.4-FPM + extensions
│   └── nginx/default.conf          # Config Nginx Symfony
├── docker-compose.yml              # Stack complète
├── docker-compose.override.yml     # Overrides dev
├── docker-compose.prod.yml         # Overrides prod
├── Makefile                        # Raccourcis
├── .dockerignore
├── .env.local.example              # Template pour chaque client
├── src/
│   ├── Entity/
│   │   └── Trait/SeoTrait.php      # Module SEO
│   ├── Controller/
│   │   └── SitemapController.php   # Sitemap XML
│   ├── Model/
│   │   └── TenantAwareInterface.php # Préparation multi-tenant
│   └── Service/
│       └── SiteContext.php          # Résolution du site courant
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
