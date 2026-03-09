# Blog & Web — CMS Platform

## Projet

CMS Symfony maison transformé en plateforme commercialisable. Chaque client reçoit une instance clonée avec son propre thème, sa BDD, et sa configuration. Le code est conçu pour permettre une migration future vers du multi-tenant mutualisé si nécessaire.

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS (migration depuis PHP 8.1 / Symfony 6.1)
- **ORM** : Doctrine ORM + Migrations
- **Admin** : EasyAdmin Bundle 4.x
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Stimulus/Hotwire
- **Templates** : Twig 3
- **BDD** : MariaDB 11 (via Docker)
- **Infra** : Docker (PHP-FPM 8.4 + Nginx + MariaDB + Mailcatcher)
- **IA** : LintellO (Mistral) — architecture prévue, implémentation ultérieure

## Décisions architecturales

### Clone par client (pas de multi-tenant)

Chaque client = une instance séparée (repo cloné, BDD dédiée, .env propre).

**Pourquoi :**
- Le code actuel fonctionne en single-site — pas de refactoring massif
- Isolation totale (sécurité, performance)
- 20-30 clients max, pas besoin de mutualisation
- Un bug chez un client n'affecte pas les autres

**Conventions pour migration future vers multi-tenant :**
- Toujours utiliser `SiteContext::getCurrentSite()`, jamais `->find(1)` en dur
- Toutes les requêtes passent par les méthodes des Repository (pas de `findAll()` brut)
- Prévoir `TenantAwareInterface` sur les entités de contenu
- Le jour J : ajouter `site_id` + Doctrine Filter global

### Thème par instance (pas de multi-thème dynamique)

Chaque instance a son propre dossier `templates/` et ses variables CSS.

**Personnalisation :** via CSS custom properties chargées depuis l'entité `Site` :
```twig
<style>:root {
  --primary: {{ site.primaryColor|default('#0455C0') }};
  --secondary: {{ site.secondaryColor|default('#F1A341') }};
}</style>
```

Les SCSS utilisent `var(--primary)` pour permettre la personnalisation sans rebuild Webpack.

### Facturation manuelle

Gestion des abonnements dans le dashboard super-admin (dates, statuts, plans). Champs `stripe_id` prévus (nullable) pour intégration Stripe ultérieure.

### Agent IA — LintellO (Mistral)

Architecture préparée mais non implémentée :
- `AiAssistantInterface` pour abstraction du provider
- Controller `/admin/ai/generate` (structure vide)
- Stimulus controller JS (boutons dans l'admin EasyAdmin)
- Configuration du provider dans `.env` (`AI_PROVIDER`, `AI_API_KEY`, `AI_MODEL`)

---

## Plan d'action

### Phase 1 — Upgrade + Docker + Sécurité + Nettoyage (2-3 semaines)

#### 1.1 Passage sous Docker complet

Conteneuriser toute l'application. Fini le serveur PHP local — tout tourne dans Docker.

**Stack Docker :**

| Service | Image | Port | Rôle |
|---------|-------|------|------|
| `php` | PHP 8.4-FPM (custom Dockerfile) | 9000 (interne) | App Symfony + Composer + extensions |
| `nginx` | Nginx Alpine | 8080 → 80 | Reverse proxy + serveur statique |
| `db` | MariaDB 11 | 3306 | Base de données |
| `node` | Node 20 Alpine | - | Build Webpack Encore (run only) |
| `mailer` | Mailpit (remplace Mailcatcher) | 1025/8025 | Dev : capture des emails |

- [ ] Créer `docker/php/Dockerfile` — PHP 8.4-FPM avec extensions (pdo_mysql, intl, gd, zip, opcache, apcu)
- [ ] Créer `docker/nginx/default.conf` — Config Nginx pour Symfony (front controller `index.php`)
- [ ] Réécrire `docker-compose.yml` — Tous les services, volumes, networks
- [ ] Créer `docker-compose.override.yml` — Overrides dev (ports exposés, xdebug, mailpit)
- [ ] Créer `docker-compose.prod.yml` — Overrides prod (opcache max, pas de xdebug, restart always)
- [ ] Créer `Makefile` — Raccourcis : `make up`, `make down`, `make sh`, `make db`, `make cc`, `make assets`, `make migrate`
- [ ] Configurer `.env` avec `DATABASE_URL=mysql://app:app@db:3306/blog_web`
- [ ] Configurer `doctrine.yaml` avec `server_version: 'mariadb-11.0'`
- [ ] Vérifier que toutes les migrations passent sur MariaDB
- [ ] Ajouter `.dockerignore`

**Fichiers :**
- Nouveau : `docker/php/Dockerfile`
- Nouveau : `docker/nginx/default.conf`
- Réécrit : `docker-compose.yml`
- Réécrit : `docker-compose.override.yml`
- Nouveau : `docker-compose.prod.yml`
- Nouveau : `Makefile`
- Nouveau : `.dockerignore`
- Modifié : `.env`, `config/packages/doctrine.yaml`

**Workflow dev après Docker :**
```bash
make up          # Lance tous les containers
make sh          # Shell dans le container PHP
make assets      # npm run dev dans le container Node
make db          # Reset BDD : drop + create + migrate + fixtures
make cc          # Cache clear
make logs        # Logs de tous les containers
make stop        # Stop sans supprimer
make down        # Stop + supprime les containers
```

#### 1.2 Migration PHP 8.4 + Symfony 7.4 LTS

- [ ] Mettre à jour `composer.json` : `php >= 8.4`, `symfony/* 7.4.*`
- [ ] Exécuter `composer update` dans le container PHP et résoudre les incompatibilités
- [ ] Adapter le code aux deprecations Symfony 7 (security, routing, forms)
- [ ] Mettre à jour EasyAdmin vers la version compatible Symfony 7
- [ ] Mettre à jour les dépendances npm (`package.json`)
- [ ] Tester le build Webpack Encore dans le container Node
- [ ] Exploiter les nouveautés PHP 8.4 si pertinent (property hooks, etc.)

**Fichiers impactés :**
- `composer.json`, `composer.lock`, `symfony.lock`
- `package.json`, `package-lock.json`
- `config/packages/security.yaml` (API Symfony 7)
- `config/bundles.php`
- Tous les controllers, entités, formulaires (adaptations mineures)

#### 1.3 Corriger les failles de sécurité critiques

- [ ] **Reset password** : implémenter un flow token-based avec `SymfonyCasts\VerifyEmailBundle` (déjà installé). Supprimer la redirection directe `/find` → `/user/{id}/edit_pass`
- [ ] **IDOR profil** : ajouter `if ($this->getUser() !== $user) throw AccessDenied` dans `UserController::edit()` et `editPass()`
- [ ] **XSS** : ajouter `HtmlSanitizer` Symfony sur le contenu article/page avant persistance
- [ ] **Null checks** : déplacer le guard `if (!$article)` AVANT `$article->getSlug()` dans `ArticleController::show()`. Ajouter null check dans `PageController::show()`
- [ ] **CSRF** : décommenter `csrf_protection: true` dans `config/packages/framework.yaml`
- [ ] **Comment auth** : ajouter `denyAccessUnlessGranted('ROLE_USER')` dans le bloc commentaire de `ArticleController`
- [ ] **Admin updateEntity** : surcharger `updateEntity()` dans `UserCrudController` pour ne pas écraser le hash password

**Fichiers :**
- `src/Controller/HomeController.php` (supprimer route `/find` actuelle)
- `src/Controller/UserController.php` (ownership checks)
- `src/Controller/ArticleController.php` (null check, auth commentaire)
- `src/Controller/PageController.php` (null check)
- `src/Controller/Admin/UserCrudController.php` (updateEntity)
- `config/packages/framework.yaml` (CSRF)
- Nouveau : service `HtmlSanitizer` config

#### 1.4 Nettoyage du code mort

- [ ] Supprimer `src/Repository/DataUserRepository.php`
- [ ] Supprimer `src/Form/User1Type.php`
- [ ] Supprimer l'import `ContainerCxexD47\getCategorieRepositoryService` dans `ArticleCrudController`
- [ ] Supprimer ou finaliser `src/Controller/CommentController.php` (stub)
- [ ] Supprimer ou finaliser `src/Controller/TagController.php` (stub)
- [ ] Supprimer la méthode morte `DashboardController::url()`
- [ ] Nettoyer les templates stub (`site/index.html.twig`, `tag/index.html.twig`, `media/index.html.twig`)
- [ ] Corriger le typo `caterogires.html.twig` → `categories.html.twig`
- [ ] Corriger `mappedBy: 'User'` → `mappedBy: 'user'` dans `User.php`
- [ ] Supprimer la boucle morte dans `CategorieController::show()`
- [ ] Corriger `CategorieRepository::findByArticle()` (DQL invalide)
- [ ] Déplacer `phpdocumentor/reflection-docblock` et `phpstan/phpdoc-parser` en `require-dev`

#### 1.5 Conventions future-proof

- [ ] Créer `src/Service/SiteContext.php` — retourne `Site` via `find(1)` pour l'instant, remplaçable par résolution sous-domaine plus tard
- [ ] Remplacer tous les `->find('1')` / `->find(1)` par `$this->siteContext->getCurrentSite()`
- [ ] Créer `src/Model/TenantAwareInterface.php` (interface vide pour marquer les entités qui auront un `site_id` futur)
- [ ] Centraliser les requêtes dans les repositories (vérifier qu'aucun controller ne fait de DQL inline)

**Fichiers :**
- Nouveau : `src/Service/SiteContext.php`
- Nouveau : `src/Model/TenantAwareInterface.php`
- `src/Controller/Admin/DashboardController.php` (remplacer find(1))

#### 1.6 Corrections fonctionnelles mineures

- [ ] Fixer `AppExtension::menuLink()` pour gérer les menus sans lien (return '#')
- [ ] Ajouter un null check sur `widget_service.findLastArticle` dans `base.html.twig`
- [ ] Fixer `Categorie.featured_media` : transformer le SMALLINT en vraie relation ManyToOne Media
- [ ] Ajouter les index manquants : `article.slug` (UNIQUE), `page.slug` (UNIQUE), `categorie.slug` (UNIQUE), `tag.slug` (UNIQUE), `article.published`, `menu.is_visible`
- [ ] Password minimum → 12 caractères dans `RegistrationFormType`

---

### Phase 2 — Module SEO (1 semaine)

#### 2.1 SeoTrait

- [ ] Créer `src/Entity/Trait/SeoTrait.php` avec : `seoTitle` (70), `seoDescription` (160), `seoKeywords` (255), `noIndex` (bool), `canonicalUrl` (255, nullable)
- [ ] Appliquer le trait sur `Article`, `Page`, `Categorie`
- [ ] Créer la migration Doctrine

**Fichier :**
- Nouveau : `src/Entity/Trait/SeoTrait.php`
- Modifiés : `src/Entity/Article.php`, `src/Entity/Page.php`, `src/Entity/Categorie.php`

#### 2.2 Champs SEO globaux sur Site

- [ ] Ajouter à `Site` : `defaultSeoTitle`, `defaultSeoDescription`, `googleAnalyticsId`, `googleSearchConsole`, `favicon` (FK Media)
- [ ] Ajouter champs couleurs pour thème : `primaryColor`, `secondaryColor`, `fontFamily`

**Fichier :** `src/Entity/Site.php`

#### 2.3 Rendu Twig

- [ ] Créer un block `{% block seo %}` dans `base.html.twig` avec : `<title>`, `<meta description>`, `<meta keywords>`, `<link canonical>`, `<meta robots>`
- [ ] Ajouter les balises Open Graph (`og:title`, `og:description`, `og:image`, `og:url`, `og:type`)
- [ ] Ajouter les balises Twitter Cards (`twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`)
- [ ] Ajouter Schema.org JSON-LD pour les articles (`Article`, `BreadcrumbList`)
- [ ] Fallback : si `seoTitle` vide → utiliser le `title` de l'entité. Si aucun → `site.defaultSeoTitle`

**Fichiers :**
- `templates/base.html.twig`
- `templates/article/show.html.twig`
- `templates/page/show.html.twig`

#### 2.4 Sitemap XML

- [ ] Créer `src/Controller/SitemapController.php` — route `/sitemap.xml`
- [ ] Lister tous les articles et pages publiés avec `<lastmod>`, `<changefreq>`, `<priority>`
- [ ] Ajouter les catégories
- [ ] Template Twig `sitemap/index.xml.twig`

#### 2.5 Admin EasyAdmin

- [ ] Ajouter un onglet "SEO" dans `ArticleCrudController`, `PageCrudController`, `CategorieCrudController`
- [ ] Champs : seoTitle (avec compteur 70 chars), seoDescription (compteur 160 chars), noIndex, canonicalUrl
- [ ] Ajouter les champs SEO dans `SiteCrudController`

---

### Phase 3 — Architecture Agent IA (2-3 jours)

> **NE PAS IMPLÉMENTER L'APPEL API** — Préparer uniquement la structure.

#### 3.1 Architecture backend

- [ ] Créer `src/Service/Ai/AiAssistantInterface.php` avec méthodes : `generateContent(string $prompt): string`, `improveContent(string $content): string`, `generateSeoDescription(string $content): string`
- [ ] Créer `src/Service/Ai/NullAiAssistant.php` (implémentation vide, retourne des messages "non configuré")
- [ ] Créer `src/Controller/Admin/AiController.php` — route `/admin/ai/generate` (POST, JSON)
- [ ] Ajouter dans `.env` : `AI_PROVIDER=none`, `AI_API_KEY=`, `AI_MODEL=`, `AI_BASE_URL=`

**Fichiers :**
- Nouveau : `src/Service/Ai/AiAssistantInterface.php`
- Nouveau : `src/Service/Ai/NullAiAssistant.php`
- Nouveau : `src/Controller/Admin/AiController.php`

#### 3.2 Architecture frontend

- [ ] Créer `assets/controllers/ai_assistant_controller.js` (Stimulus) — boutons "Générer", "Améliorer", "SEO auto"
- [ ] Prévoir l'injection dans les formulaires EasyAdmin (article, page)
- [ ] UI : boutons désactivés avec message "Agent IA non configuré" tant que `AI_PROVIDER=none`

#### 3.3 Documentation

- [ ] Documenter dans ce fichier comment brancher LintellO :
  1. Créer `src/Service/Ai/LintelloAiAssistant.php` implémentant `AiAssistantInterface`
  2. Configurer `.env` : `AI_PROVIDER=lintello`, `AI_API_KEY=xxx`, `AI_BASE_URL=xxx`
  3. Enregistrer le service dans `services.yaml`

---

### Phase 4 — Script de provisioning client (3-5 jours)

#### 4.1 Commande Symfony

- [ ] Créer `src/Command/ClientCreateCommand.php` — `bin/console app:client:create`
- [ ] Paramètres : `--name`, `--domain`, `--admin-email`, `--theme` (default/corporate/blog)
- [ ] Actions : cloner le repo, créer le `docker-compose.override.yml` client (ports uniques, nom BDD), générer `.env.local`, lancer les containers, exécuter les migrations, créer le compte admin, copier le thème choisi

#### 4.2 Infrastructure Docker par client

Chaque instance client = un dossier avec son propre `docker-compose.override.yml` :
```
/var/www/clients/
├── client-alpha/          # Clone du repo
│   ├── docker-compose.yml         # Commun (symlink ou copie)
│   ├── docker-compose.override.yml # Ports uniques, nom BDD, domaine
│   ├── .env.local                  # Config spécifique
│   └── ...
├── client-beta/
│   └── ...
```

- [ ] Script bash `scripts/provision.sh` — orchestre le clone + config Docker + lancement
- [ ] Template `docker-compose.override.yml` client (ports dynamiques, labels Traefik optionnel)
- [ ] Template Nginx reverse proxy global (ou Traefik pour le routage par domaine)
- [ ] Documentation d'installation pas à pas

**Fichiers :**
- Nouveau : `src/Command/ClientCreateCommand.php`
- Nouveau : `scripts/provision.sh`
- Nouveau : `docker/templates/docker-compose.client.yml.template`
- Nouveau : `docs/installation.md`

---

### Phase 5 — Thèmes de base (2-3 semaines)

#### 5.1 Infrastructure thème

- [ ] Ajouter champ `theme` sur `Site` (varchar, default 'default')
- [ ] Modifier `assets/css/base/variables.scss` : remplacer les couleurs hardcodées par `var(--primary)`, `var(--secondary)`, etc.
- [ ] Injecter les CSS custom properties dans `base.html.twig` depuis `Site`
- [ ] Créer un `TwigGlobal` ou modifier `SiteContext` pour exposer les variables de thème à tous les templates

#### 5.2 Thèmes

- [ ] **default** : thème actuel Blog & Web (bleu/orange, Expletus Sans)
- [ ] **corporate** : sobre, professionnel (gris/bleu foncé, sans-serif)
- [ ] **blog** : moderne, léger (blanc/accent couleur, typographie éditoriale)
- [ ] Chaque thème = un jeu de variables CSS + éventuellement quelques overrides de templates

#### 5.3 Personnalisation client

- [ ] Interface dans `SiteCrudController` : couleur primaire (ColorField), couleur secondaire, font family (choix parmi 5-6 fonts Google), logo
- [ ] Preview en temps réel dans l'admin (bonus, si le temps le permet)

---

### Phase 6 — Dashboard super-admin (1-2 semaines)

#### 6.1 Concept

Un dashboard séparé (ou une section protégée par `ROLE_SUPER_ADMIN`) qui agrège les informations de toutes les instances clientes. Pour l'approche clone, cela peut être :
- Une application Symfony séparée qui se connecte aux BDD de chaque client
- Ou un simple tableau de bord avec les infos remontées via API/webhook

#### 6.2 Fonctionnalités

- [ ] Liste des clients avec statut (actif/inactif/expiré)
- [ ] Infos par client : nom, domaine, date de création, abonnement, dernière connexion
- [ ] Actions : activer/désactiver un site, accéder à l'admin du client
- [ ] Vue stats globale : nombre de sites, revenus, alertes d'expiration

#### 6.3 Rôle

- [ ] Ajouter `ROLE_SUPER_ADMIN` dans `RoleEnum` et `security.yaml`

---

### Phase 7 — Abonnement + facturation manuelle (2-3 semaines)

#### 7.1 Entités

- [ ] Créer `src/Entity/Client.php` : id, name, email, phone, company, created_at
- [ ] Créer `src/Entity/Subscription.php` : id, client_id (FK), plan (enum: free/basic/premium), status (enum: active/expired/cancelled/suspended), started_at, expires_at, price (decimal), notes, stripe_subscription_id (nullable, pour le futur)
- [ ] Relation : Client 1:M Subscription (historique), Site M:1 Client

#### 7.2 Admin

- [ ] CRUD `ClientCrudController` dans le dashboard super-admin
- [ ] CRUD `SubscriptionCrudController` avec filtres par statut
- [ ] Alertes visuelles : abonnements expirant dans < 30 jours

#### 7.3 Automatisation

- [ ] Créer `src/Command/CheckSubscriptionsCommand.php` — `bin/console app:subscriptions:check`
- [ ] Cron quotidien : passer les abonnements expirés en `status = expired`
- [ ] Optionnel : envoyer un email d'alerte au client X jours avant expiration

---

## Conventions de code

### Général
- PHP 8.4 avec typed properties, readonly quand approprié, enums
- Symfony 7.4 LTS — suivre les conventions Symfony
- Attributs PHP 8 pour le routing (`#[Route]`), l'ORM (`#[ORM\Entity]`), la validation (`#[Assert\...]`)
- Nommage : PascalCase classes, camelCase méthodes/variables, snake_case BDD

### Architecture
- **Jamais** de `->find(1)` en dur → utiliser `SiteContext::getCurrentSite()`
- **Jamais** de `findAll()` dans les controllers → passer par les méthodes Repository typées
- **Toujours** vérifier l'ownership avant modification d'une ressource utilisateur
- **Toujours** sanitiser le HTML avant persistance (articles, pages)
- Les entités de contenu implémentent `TenantAwareInterface` (préparation multi-tenant)

### Sécurité
- CSRF activé globalement
- `denyAccessUnlessGranted()` sur toute route sensible
- `HtmlSanitizer` sur tout contenu utilisateur rendu avec `|raw`
- Mots de passe : minimum 12 caractères, hash `auto` (bcrypt/argon2id)
- Pas de données sensibles dans les URLs

### Front
- SCSS avec variables CSS custom properties (pas de couleurs hardcodées)
- Stimulus controllers pour le JS interactif
- Bootstrap 5 pour la structure, personnalisé via `_variables-custom.scss`

---

## Problèmes connus (issus de l'audit)

### Critiques (à corriger en Phase 1)
- Reset password sans token — n'importe qui peut changer n'importe quel mot de passe
- IDOR sur `/user/{id}/edit` — pas de vérification d'ownership
- XSS via `|raw` sans sanitisation HTML côté serveur
- Null pointer dans `ArticleController::show()` avant le null check
- CSRF commenté dans `framework.yaml`

### Importants
- Conflit MySQL/PostgreSQL résolu → MariaDB 11 (migrations MySQL compatibles, Docker reconfiguré)
- `DataUserRepository` référence une entité inexistante
- `CategorieRepository::findByArticle()` — DQL invalide
- `Categorie.featured_media` — SMALLINT au lieu de relation ORM
- N+1 dans les menus (base template) et `CategorieController`
- Recherche `LIKE '%..%'` sur LONGTEXT sans index full-text
- Aucun index UNIQUE sur les slugs
- `published_at` jamais affecté
- Contact form non câblé au mailer
- Vérification email installée mais non activée

### Mineurs
- Typo `adress_1`/`adress_2`, `caterogires.html.twig`
- `mappedBy: 'User'` au lieu de `'user'`
- Import container généré dans `ArticleCrudController`
- Password min 6 chars (passer à 12)
- Archives widget hardcodé
- Liens sociaux en `href="#"`

---

## Commandes utiles

### Docker (workflow principal)

```bash
# Démarrage
make up                    # Lance tous les containers (PHP, Nginx, MariaDB, Mailpit)
make down                  # Stop + supprime les containers
make stop                  # Stop sans supprimer
make restart               # Restart tous les services

# Shell et debug
make sh                    # Shell bash dans le container PHP
make logs                  # Logs de tous les containers
make logs s=php            # Logs d'un service spécifique

# Base de données
make db                    # Reset complet : drop + create + migrate
make migrate               # Juste les migrations

# Assets
make assets                # npm run dev (dans container Node)
make assets-build          # npm run build (prod)

# Symfony
make cc                    # Cache clear
make console c="debug:router"  # Exécuter une commande console

# Provisioning client (Phase 4)
make client name="mon-client" email="admin@client.com" theme="default"

# Abonnements (Phase 7)
make check-subs            # Vérifier les expirations
```

### Accès dev

| Service | URL |
|---------|-----|
| Application | http://localhost:8080 |
| Mailpit (emails) | http://localhost:8025 |
| MariaDB | localhost:3306 (user: app, pass: app) |

### Sans Docker (fallback)

```bash
composer install
npm install && npm run dev
symfony server:start
```

---

## Structure cible (après toutes les phases)

```
blog_web/
├── docker/
│   ├── php/
│   │   └── Dockerfile                   # Phase 1 — PHP 8.4-FPM + extensions
│   ├── nginx/
│   │   └── default.conf                 # Phase 1 — Config Nginx Symfony
│   └── templates/
│       └── docker-compose.client.yml.template  # Phase 4 — Template provisioning
├── scripts/
│   └── provision.sh                     # Phase 4 — Script provisioning client
├── docker-compose.yml                   # Phase 1 — Stack complète
├── docker-compose.override.yml          # Phase 1 — Overrides dev
├── docker-compose.prod.yml              # Phase 1 — Overrides prod
├── Makefile                             # Phase 1 — Raccourcis Docker/Symfony
├── .dockerignore                        # Phase 1
├── src/
│   ├── Command/
│   │   ├── ClientCreateCommand.php          # Phase 4
│   │   └── CheckSubscriptionsCommand.php    # Phase 7
│   ├── Controller/
│   │   ├── Admin/
│   │   │   ├── AiController.php             # Phase 3
│   │   │   ├── ClientCrudController.php     # Phase 7
│   │   │   ├── SubscriptionCrudController.php # Phase 7
│   │   │   └── ... (existants)
│   │   ├── SitemapController.php            # Phase 2
│   │   └── ... (existants, corrigés)
│   ├── Entity/
│   │   ├── Trait/
│   │   │   └── SeoTrait.php                 # Phase 2
│   │   ├── Client.php                       # Phase 7
│   │   ├── Subscription.php                 # Phase 7
│   │   └── ... (existants, avec SeoTrait)
│   ├── Model/
│   │   └── TenantAwareInterface.php         # Phase 1
│   ├── Service/
│   │   ├── Ai/
│   │   │   ├── AiAssistantInterface.php     # Phase 3
│   │   │   └── NullAiAssistant.php          # Phase 3
│   │   ├── SiteContext.php                  # Phase 1
│   │   └── ... (existants)
│   └── ...
├── docs/
│   └── installation.md                  # Phase 4 — Guide d'installation client
└── ...
```
