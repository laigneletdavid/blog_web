# Blog & Web — Roadmap Évolutive

## Vision produit

CMS Symfony modulaire. Base commune (vitrine) enrichie par des modules activables par site. Chaque client paie pour ce qu'il utilise. Le SUPER_ADMIN et le FREELANCE activent/désactivent les modules via l'admin.

### Offres commerciales (bundles)

| Bundle | Modules activés | Cible |
|--------|----------------|-------|
| **Vitrine** | `vitrine`, `services` | Freelance, artisan, PME |
| **Vitrine + Blog** | + `blog` | Freelance, consultant, asso communication |
| **Vitrine + Blog + Catalogue** | + `catalogue` | Commerce, artisan produits |
| **Vitrine + Blog + E-commerce** | + `catalogue`, `ecommerce` | Petite boutique en ligne |

### Sous-modules (ajoutables à tout bundle)

| Sous-module | Ce qu'il apporte | Cible |
|-------------|-----------------|-------|
| **Événements** (`events`) | Calendrier, alertes abonnés | Assos, écoles, collectivités |
| **Pages privées** (`private_pages`) | Contenu restreint aux membres connectés | Assos d'entreprises, clubs |
| **Annuaire** (`directory`) | Liste membres/entreprises (connectés uniquement) | Assos d'entreprises, réseaux |

> Côté code : un seul repo. Les modules sont de la config sur l'entité `Site`, pas des bundles Symfony séparés.

---

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS
- **ORM** : Doctrine ORM 3.3 + Migrations
- **Admin** : EasyAdmin Bundle 4.12
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Stimulus/Hotwire
- **Templates** : Twig 3
- **BDD** : MariaDB 11
- **Infra** : Docker (PHP-FPM 8.4 + Nginx + MariaDB 11 + Mailpit)
- **Mailer** : Brevo (via `symfony/brevo-mailer`)

---

## Rôles & accès

```
ROLE_USER < ROLE_AUTHOR < ROLE_ADMIN < ROLE_FREELANCE < ROLE_SUPER_ADMIN
```

| Rôle | Qui | Accès |
|------|-----|-------|
| `ROLE_USER` | Visiteur inscrit | Lecture, commentaires, profil, contenu privé |
| `ROLE_AUTHOR` | Rédacteur client | Création/édition articles et pages |
| `ROLE_ADMIN` | Admin client | Gestion complète du site (users, menus, médias, contenus) |
| `ROLE_FREELANCE` | Freelance revendeur | Idem SUPER_ADMIN sur ses propres sites uniquement |
| `ROLE_SUPER_ADMIN` | David | Accès total, tous les sites, modules, config infrastructure |

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
- **Toujours** vérifier `enabledModules` dans le DashboardController avant d'afficher un menu/CRUD

### Sécurité
- CSRF activé globalement
- `denyAccessUnlessGranted()` sur toute route sensible
- Password min 12 caractères, hash `auto`

### Front
- SCSS avec CSS custom properties (pas de couleurs hardcodées)
- Stimulus pour le JS interactif
- Bootstrap 5 personnalisé via custom properties
- `loading="lazy"` systématique sur les images

### Modules
- Chaque module = entité(s) + CRUD(s) + partial(s) Twig + route(s) front
- Le DashboardController masque les menus selon `site.enabledModules`
- Les routes front retournent 404 si le module n'est pas activé pour le site courant
- Nouveau module = nouvelle entrée dans `ModuleEnum.php`, rien d'autre à câbler

---

## Phases 1–6 : TERMINÉES ✅

> Référence complète dans `CLAUDE.md`. Résumé :

| Phase | Contenu | Statut |
|-------|---------|--------|
| Phase 1 | Docker + Upgrade PHP 8.4/Symfony 7.4 + Sécurité + Nettoyage | ✅ |
| Phase 2 | Module SEO (SeoTrait, Sitemap, robots.txt, Open Graph, Schema.org, WebP, srcset) | ✅ |
| Phase 3 | Système multi-thèmes (6 thèmes, ThemeService, theme.yaml, admin browser) | ✅ |
| Phase 4 | Éditeur TipTap + UX (stats, notifications Brevo, pagination, recherche, archives) | ✅ |
| Phase 5 | Refonte design & CSS (thème default moderne, header sticky, homepage SaaS) | ✅ |
| Phase 6 | Fondations Modules + Services + Tags | ✅ |

---

## Dette technique (héritée de CLAUDE.md — à solder)

> Ces points sont des restes des Phases 1–5. À traiter en priorité avant les nouvelles phases.

### DT.1 — Docker production ⚠️

- [ ] Créer `docker-compose.prod.yml` — opcache max, restart always, pas de Xdebug, healthchecks
- [ ] Script `deploy.sh` — git pull → composer install --no-dev → migrations → cache clear → assets build
- [ ] Rollback auto si migration échoue
- [ ] Commandes Makefile : `make deploy`, `make backup`, `make restore`

### DT.2 — Performance

- [ ] N+1 menus (base template) → eager loading ou cache Twig
- [ ] Commande `app:media:regenerate-sizes` — régénérer les variantes WebP/srcset pour les images existantes

### DT.3 — Corrections mineures

- [ ] Typos `adress_1` / `adress_2` → `address_1` / `address_2` (entité + migration + templates)
- [ ] Abonnements `subscribeNews` / `subscribeArticles` sur User : stockés mais jamais utilisés → activer ou supprimer
- [ ] Vérification email : installée mais non activée → activer le flow complet (VerifyEmailBundle)

### DT.4 — Affinements CSS (Phase 5.7)

- [ ] Affiner les couleurs (nuances primary/secondary/accent)
- [ ] Ajuster les marges/paddings sur certaines sections
- [ ] Vérifier le rendu sur toutes les pages (article detail, page, catégories, recherche)

### DT.5 — Sécurité production

- [ ] Backups BDD automatisés (cron mysqldump compressé, rotation 30 jours)
- [ ] Healthcheck endpoint `/healthz` (PHP + BDD + disque)
- [ ] Rate limiting login + formulaire contact (Symfony RateLimiter)
- [ ] Anti-spam formulaire contact : honeypot field (champ caché CSS, rempli = bot)
- [ ] Headers CSP affinés dans Nginx
- [ ] Fail2ban sur les tentatives /admin répétées
- [ ] SSL/HTTPS : Certbot ou Traefik reverse proxy + Let's Encrypt auto-renew

---

## Phase 6 — Fondations Modules + Services + Tags ✅

> Temps réel : ~1 jour

### 6.1 Système enabledModules sur Site ✅

- [x] `src/Enum/ModuleEnum.php` — enum string-backed (8 modules : vitrine, services, blog, catalogue, ecommerce, events, private_pages, directory)
- [x] `enabledModules` (JSON, default `['vitrine']`) sur `Site` + `hasModule(string|ModuleEnum): bool`
- [x] `SiteContext::hasModule()` — proxy vers `Site::hasModule()`
- [x] `ModulesCrudController.php` — CRUD dédié pour les modules (séparé de SiteCrudController)
- [x] Migration Doctrine
- [x] `DashboardController` : menus conditionnés par modules, lien "Modules" dans section Apparence
- [x] Guard routes front : `ArticleController`, `CategorieController`, `ServiceController` vérifient `hasModule()`

**Permissions admin :**
- Modules → `ROLE_SUPER_ADMIN` uniquement
- Services menu → `ROLE_ADMIN`+
- Tags menu → `ROLE_AUTHOR`+

**Fichiers créés :** `ModuleEnum.php`, `ModulesCrudController.php`
**Fichiers modifiés :** `Site.php`, `SiteContext.php`, `DashboardController.php`, `SiteCrudController.php`, `ArticleController.php`, `CategorieController.php`

### 6.2 Entité Service ✅

- [x] `src/Entity/Service.php` — title, slug (unique), shortDescription, blocks (JSON), content (TEXT cache), icon, image (FK Media), linkedPage (FK Page nullable), link (URL externe nullable), position, isActive
- [x] Virtual `getBlocksJson()`/`setBlocksJson()` — même pattern que Article/Page
- [x] Priorité des liens : blocks (page détail) > linkedPage (FK Page) > link (URL externe)
- [x] `ServiceRepository.php` — `findAllActive()`, `findOneActiveBySlug()`
- [x] `ServiceCrudController.php` — Panels Contenu + Paramètres (slug auto, linkedPage AssociationField, link externe)
- [x] `ServiceController.php` — `GET /services` (index), `GET /service/{slug}` (show si blocks, sinon redirect)
- [x] `_partials/_services_grid.html.twig` — grille réutilisable avec logique de lien prioritaire
- [x] `service/index.html.twig`, `service/show.html.twig`
- [x] Intégration 6 thèmes homepage : fallback conditionnel (`{% if services|default([])|length > 0 %}` → services réels, sinon contenu menus existant)
- [x] `services.scss` + import `main.scss`
- [x] `ContentSanitizeListener` — compile blocks Service → content HTML
- [x] `SitemapController` — services ajoutés (priority 0.6, conditionné par module)

**Fichiers créés :** `Service.php`, `ServiceRepository.php`, `ServiceCrudController.php`, `ServiceController.php`, `_services_grid.html.twig`, `service/index.html.twig`, `service/show.html.twig`, `services.scss`
**Fichiers modifiés :** `DashboardController.php`, `HomeController.php`, `ContentSanitizeListener.php`, `SitemapController.php`, `sitemap/index.xml.twig`, `main.scss`, 6 templates homepage thèmes

### 6.3 Tags front + Nuage de tags ✅

- [x] `TagController.php` — `GET /tag/{slug}` avec pagination Doctrine, guard `hasModule('blog')`
- [x] `TagCrudController.php` — name, slug (auto), AssociationField articles
- [x] `ArticleCrudController.php` — AssociationField tags ajouté dans panel Paramètres
- [x] `Tag::__toString()` ajouté pour affichage EasyAdmin
- [x] `TagRepository::findAllWithArticleCount()` — LEFT JOIN articles publiés, HAVING count > 0
- [x] `ArticleRepository::findPublishedByTag()` — pagination Doctrine Paginator
- [x] `WidgetService::findTagCloud()` — proxy vers TagRepository
- [x] `tag/show.html.twig` — liste articles + sidebar (tag cloud, catégories, archives) + pagination
- [x] `widgets/tag_cloud.html.twig` — pills avec compteur articles
- [x] Tag cloud intégré : sidebar blog (default, corporate, artisan), article/show, tag/show
- [x] Tag pills dans `article/item.html.twig` (cards articles)
- [x] `tags.scss` — `.tag-cloud`, `.tag-pill`, `.tag-pill-sm`, `.tag-pills` + hover primary

**Bug fix :** `Categorie.php` avait `mappedBy: 'categories'` au lieu de `'categorie'` — mapping Doctrine invalide corrigé

**Fichiers créés :** `TagController.php`, `TagCrudController.php`, `tag/show.html.twig`, `widgets/tag_cloud.html.twig`, `tags.scss`
**Fichiers modifiés :** `TagRepository.php`, `ArticleRepository.php`, `WidgetService.php`, `ArticleCrudController.php`, `Tag.php`, `Categorie.php`, `DashboardController.php`, `main.scss`, `article/item.html.twig`, `article/show.html.twig`, sidebars blog thèmes

---

## Phase 7 — Refonte UX Blog (listing + article show)

> Temps estimé : ~1 jour
> Prérequis : Phase 6.3 (tags front) pour affichage dans les cards

### 7.1 Page /articles (blog listing)

**Problèmes actuels** : layout générique, pas de hiérarchie visuelle, pas de filtrage interactif.

**Refonte :**

- [ ] Header de page : titre "Blog" (ou custom via Site), description, compteur total articles
- [ ] Article featured (sticky) : le plus récent (ou `isFeatured=true`) affiché en large card pleine largeur en haut
  - Ajouter `isFeatured` (boolean, default false) sur `Article` + migration
  - `ArticleRepository::findFeatured()` — dernier article featured publié
- [ ] Grille articles : cards en 2 colonnes desktop / 1 colonne mobile
- [ ] Card article repensée :
  - Image (aspect ratio fixe 16:9, object-fit cover)
  - Catégorie en badge coloré (coin supérieur)
  - Titre (clamp 2 lignes)
  - Extrait (clamp 3 lignes)
  - Ligne meta : date + temps de lecture + tags en mini-pills
  - Hover : légère élévation (translateY + shadow)
- [ ] Filtrage par catégorie : pills horizontales scrollables en haut (Stimulus controller)
  - "Tous" + une pill par catégorie ayant des articles publiés
  - Filtre côté serveur (query param `?categorie=slug`) avec Turbo Frame ou rechargement classique
- [ ] Filtrage par tag : intégré dans le nuage de tags sidebar (ou sous les pills catégories sur mobile)
- [ ] Pagination : garder la pagination Doctrine existante, améliorer le style (Bootstrap pagination customisée)
- [ ] Refactoring SCSS : réécrire `article_list.scss` complètement

**Fichiers modifiés :** `Article.php` (isFeatured), `ArticleRepository.php`, `ArticleController.php` ou controller blog, `article/show_all.html.twig`, `article/item.html.twig`, `article_list.scss`
**Fichiers thème :** mettre à jour `blog.html.twig` de chaque thème
**Migration :** oui (isFeatured)

### 7.2 Page /article/{slug} (article show)

**Problèmes actuels** : typographie et mise en page à revoir, pas de sommaire, sidebar pas optimale.

**Refonte :**

- [ ] Layout lecture optimisé :
  - Contenu texte : max-width 720px, centré, line-height 1.8, font-size 1.1rem
  - Images dans le contenu : breakout possible (max-width 100vw ou 900px)
- [ ] Image featured : pleine largeur en haut (ou hero avec overlay selon thème)
- [ ] Meta header : catégorie badge + date + temps de lecture + auteur
- [ ] Sommaire auto (Table of Contents) :
  - Extraire les H2/H3 du contenu HTML compilé (côté Twig ou JS)
  - Afficher en sidebar sticky (desktop) ou accordion en haut (mobile)
  - Scroll spy Stimulus : highlight la section active
  - Optionnel dans `theme.yaml` : `toc: true|false`
- [ ] Tags cliquables sous le contenu (pills → lien `/tag/{slug}`)
- [ ] Bloc auteur : avatar (User.avatar FK Media, nullable), nom, bio courte (User.bio text nullable)
  - Ajouter champs `avatar` et `bio` sur User si absents + migration
- [ ] Articles connexes : refonte cards (3 en grille, même style que blog listing)
- [ ] Boutons partage : repositionnés — barre sticky gauche (desktop) ou barre fixe bas (mobile)
- [ ] Commentaires : style cards amélioré, formulaire simplifié
- [ ] Refactoring SCSS : réécrire `article.scss` complètement

**Fichiers modifiés :** `User.php` (avatar, bio), `article/show.html.twig`, `article.scss`, `comment/index.html.twig`
**Fichiers créés :** `_partials/_toc.html.twig`, `_partials/_author_card.html.twig`, `_partials/_share_bar.html.twig`
**Stimulus :** `toc_controller.js` (scroll spy), `share_controller.js` (copy link)
**Migration :** oui (User avatar + bio)

### 7.3 Design System — Composants partagés

**Objectif** : unifier les composants visuels pour que tous les thèmes soient cohérents.

- [ ] `_components/_card.html.twig` — macro Twig card réutilisable (image, badge, titre, texte, meta, tags)
- [ ] `_components/_badge.html.twig` — badge catégorie/tag avec couleur dynamique
- [ ] `_components/_pagination.html.twig` — pagination Bootstrap customisée
- [ ] `_components/_empty_state.html.twig` — état "aucun résultat" avec illustration
- [ ] `assets/css/base/components.scss` — styles composants partagés (cards, badges, pills, buttons)
- [ ] Refactoring : les thèmes utilisent les composants via `{% include %}` au lieu de dupliquer le HTML

---

## Phase 8 — Module Événements / Calendrier

> Temps estimé : ~1.5 jours
> Prérequis : Phase 6.1 (enabledModules)

### 8.1 Entité Event

| Champ | Type | Notes |
|-------|------|-------|
| `id` | int (auto) | PK |
| `title` | string(255) | Requis |
| `slug` | string(255) | Unique, auto-généré |
| `shortDescription` | text | Résumé pour les cards/listes |
| `blocks` | json (nullable) | Contenu TipTap |
| `content` | text (nullable) | HTML compilé (cache) |
| `dateStart` | datetime | Requis |
| `dateEnd` | datetime (nullable) | Null = événement ponctuel |
| `location` | string(255, nullable) | Lieu texte libre |
| `image` | ManyToOne Media (nullable) | Image illustrative |
| `isActive` | boolean (default true) | Publié/brouillon |
| `isFeatured` | boolean (default false) | Mis en avant |

+ `use SeoTrait;` pour le référencement

- [ ] Créer `src/Entity/Event.php`
- [ ] Créer `src/Repository/EventRepository.php` :
  - `findUpcoming(int $limit)` — événements futurs, triés dateStart ASC
  - `findPast(int $limit, int $offset)` — événements passés, paginés
  - `findByMonth(int $year, int $month)` — pour le widget calendrier
  - `findAllActiveForSitemap()`
- [ ] Migration Doctrine

### 8.2 CRUD Admin

- [ ] Créer `src/Controller/Admin/EventCrudController.php` :
  - Panels : "Contenu" (title, shortDescription, blocks/blocksJson, image) | "Date & Lieu" (dateStart, dateEnd, location) | "SEO" (SeoTrait) | "Paramètres" (isActive, isFeatured)
  - Liste : colonnes title, dateStart, location, isActive (toggle), isFeatured
  - Filtres : à venir / passés / tous (filtre dateStart)
  - Tri : dateStart DESC par défaut
  - Visible uniquement si module `events` activé
- [ ] Ajouter dans `DashboardController::configureMenuItems()` conditionné par module

### 8.3 Front

- [ ] Créer `src/Controller/EventController.php` :
  - `GET /evenements` — liste (prochains d'abord, puis passés, paginé)
  - `GET /evenement/{slug}` — détail
  - Guard `hasModule('events')`
- [ ] Créer templates :
  - `templates/event/index.html.twig` — liste avec séparation "À venir" / "Passés"
  - `templates/event/show.html.twig` — détail (date, lieu, map embed optionnel, contenu)
  - `templates/_partials/_event_card.html.twig` — card événement (date stylisée, titre, lieu)
  - `templates/_partials/_calendar_widget.html.twig` — mini calendrier mensuel HTML
- [ ] Stimulus : `calendar_controller.js` — navigation mois (fetch JSON des événements du mois)
- [ ] Widget "Prochains événements" pour sidebar/homepage (conditionné par module)
- [ ] Ajouter les événements au `SitemapController` (conditionné par module)
- [ ] Créer `assets/css/base/events.scss`

### 8.4 Abonnements / Alertes événements

- [ ] Activer `subscribeNews` / `subscribeArticles` existants sur User
- [ ] Ajouter `subscribeEvents` (boolean, default false) sur User + migration
- [ ] Page profil utilisateur : checkboxes pour gérer ses abonnements
- [ ] `EventNotificationService.php` — envoie email Brevo aux abonnés events quand un événement est publié
- [ ] Câbler dans `EventCrudController::persistEntity()` / `updateEntity()`

**Fichiers créés :** `Event.php`, `EventRepository.php`, `EventCrudController.php`, `EventController.php`, `EventNotificationService.php`, `event/index.html.twig`, `event/show.html.twig`, `_event_card.html.twig`, `_calendar_widget.html.twig`, `calendar_controller.js`, `events.scss`
**Fichiers modifiés :** `User.php`, `DashboardController.php`, `SitemapController.php`, `main.scss`, templates sidebar/homepage
**Migrations :** oui (Event + User.subscribeEvents)

---

## Phase 9 — Pages Privées / Contenu Restreint

> Temps estimé : ~0.5 jour
> Prérequis : Phase 6.1 (enabledModules)

### 9.1 Visibilité sur les contenus

- [ ] Créer `src/Enum/VisibilityEnum.php` :
  ```php
  enum VisibilityEnum: string {
      case PUBLIC = 'public';
      case MEMBERS = 'members';    // ROLE_USER minimum
      case ADMIN = 'admin';        // ROLE_ADMIN minimum
  }
  ```
- [ ] Ajouter `visibility` (string, default 'public') sur `Page` + migration
- [ ] Optionnel : ajouter `visibility` sur `Article` aussi
- [ ] Créer `src/Security/Voter/ContentVoter.php` — vérifie le rôle vs la visibilité
- [ ] Modifier les repositories : `findAllPublished()` filtre par visibilité selon le user courant
- [ ] Modifier les menus : masquer les liens vers les pages restreintes pour les non-connectés
- [ ] Admin : `ChoiceField::new('visibility')` dans `PageCrudController` — visible uniquement si module `private_pages` activé

### 9.2 UX page restreinte

- [ ] Créer `templates/_partials/_restricted_access.html.twig` :
  - Message "Contenu réservé aux membres"
  - Boutons "Se connecter" / "S'inscrire"
  - Conserve header/footer du site (pas de 403 brut)
- [ ] `PageController::show()` : si accès refusé, render le template restricted au lieu de throw 403

### 9.3 Annuaire membres (sous-module directory, optionnel)

- [ ] Ajouter champs optionnels sur `User` : `company` (string nullable), `jobTitle` (string nullable), `companyLogo` (FK Media nullable)
- [ ] Créer `src/Controller/DirectoryController.php` :
  - `GET /annuaire` — liste des users ROLE_USER+ avec company renseignée
  - Guard `hasModule('directory')` + `isGranted('ROLE_USER')`
- [ ] Template `templates/directory/index.html.twig` — grille cards membres
- [ ] SCSS : `directory.scss`

**Fichiers créés :** `VisibilityEnum.php`, `ContentVoter.php`, `_restricted_access.html.twig`, `DirectoryController.php`, `directory/index.html.twig`, `directory.scss`
**Fichiers modifiés :** `Page.php`, `PageRepository.php`, `PageController.php`, `PageCrudController.php`, `User.php`, `DashboardController.php`, `AppExtension.php` (menus), `main.scss`
**Migrations :** oui (Page.visibility, User company/jobTitle/companyLogo)

---

## Phase 10 — Catalogue Produits

> Temps estimé : ~1.5 jours
> Prérequis : Phase 6.1 (enabledModules), Phase 7.3 (composants partagés)

### 10.1 Entités

**`ProductCategory`** :

| Champ | Type | Notes |
|-------|------|-------|
| `id` | int (auto) | PK |
| `name` | string(255) | Requis |
| `slug` | string(255) | Unique |
| `description` | text (nullable) | |
| `image` | ManyToOne Media (nullable) | |
| `position` | integer (default 0) | |
| `isActive` | boolean (default true) | |

**`Product`** :

| Champ | Type | Notes |
|-------|------|-------|
| `id` | int (auto) | PK |
| `title` | string(255) | Requis |
| `slug` | string(255) | Unique |
| `shortDescription` | text | Pour les cards |
| `blocks` | json (nullable) | Contenu TipTap |
| `content` | text (nullable) | HTML compilé |
| `price` | decimal(10,2) | Prix TTC |
| `oldPrice` | decimal(10,2, nullable) | Prix barré (promo) |
| `category` | ManyToOne ProductCategory | |
| `tags` | ManyToMany Tag | Réutilisation des tags existants |
| `image` | ManyToOne Media | Image principale |
| `gallery` | ManyToMany Media | Images galerie |
| `isActive` | boolean (default true) | |
| `isFeatured` | boolean (default false) | |
| `position` | integer (default 0) | |

+ `use SeoTrait;`

- [ ] Créer `src/Entity/ProductCategory.php`
- [ ] Créer `src/Entity/Product.php`
- [ ] Créer repositories avec méthodes : `findAllActive()`, `findByCategory()`, `findFeatured()`, `findForSitemap()`
- [ ] Migrations Doctrine

### 10.2 Admin

- [ ] Créer `ProductCategoryCrudController.php` — liste triable, formulaire simple
- [ ] Créer `ProductCrudController.php` :
  - Panels : "Contenu" (title, shortDescription, blocks, image, gallery) | "Prix" (price, oldPrice) | "Classification" (category, tags) | "SEO" (SeoTrait) | "Paramètres" (isActive, isFeatured, position)
  - Liste : image thumb, title, price, category, isActive, isFeatured
  - Filtres : par catégorie, par statut
- [ ] Menu admin conditionné par module `catalogue`

### 10.3 Front

- [ ] `ProductController.php` :
  - `GET /produits` — grille filtrable (par catégorie, par tag)
  - `GET /produit/{slug}` — page détail (galerie, description, prix, CTA)
  - `GET /produits/categorie/{slug}` — filtre par catégorie
  - Guard `hasModule('catalogue')`
- [ ] Templates :
  - `product/index.html.twig` — grille avec sidebar filtres
  - `product/show.html.twig` — page détail (galerie lightbox, prix, description, produits similaires)
  - `_partials/_product_card.html.twig` — card produit (image, titre, prix, badge promo)
  - `_partials/_product_featured.html.twig` — widget homepage "Produits phares"
- [ ] Stimulus : `gallery_controller.js` (lightbox images), `product_filter_controller.js` (filtrage)
- [ ] Ajouter au sitemap (conditionné par module)
- [ ] SCSS : `products.scss`

**Fichiers créés :** ~15 fichiers (entités, repos, CRUDs, controllers, templates, Stimulus, SCSS)
**Migrations :** oui

---

## Phase 11 — E-commerce Light

> Temps estimé : ~2 jours
> Prérequis : Phase 10 (catalogue), compte Stripe configuré

### 11.1 Panier

- [ ] `CartService.php` — panier en session Symfony (pas de BDD) :
  - `add(Product, qty)`, `remove(Product)`, `update(Product, qty)`, `clear()`, `getTotal()`, `getItems()`
- [ ] Stimulus `cart_controller.js` — ajout au panier sans rechargement, badge compteur header
- [ ] Page `/panier` — récapitulatif, modifier quantités, supprimer, total, bouton "Commander"

### 11.2 Checkout Stripe

- [ ] `CheckoutController.php` :
  - `GET /commander` — page récapitulatif + formulaire (nom, email, adresse, téléphone)
  - `POST /commander` — crée la Stripe Checkout Session, redirige vers Stripe
  - `GET /commande/confirmation/{id}` — page merci
  - `GET /commande/annulation` — page annulation
- [ ] `StripeService.php` — crée la Checkout Session depuis le panier
- [ ] Webhook Stripe `/webhook/stripe` — écoute `checkout.session.completed`, crée la commande en BDD

### 11.3 Entité Order

| Champ | Type | Notes |
|-------|------|-------|
| `id` | int (auto) | PK |
| `reference` | string(20) | Unique, auto-généré (ex: BW-20260316-001) |
| `customerName` | string | |
| `customerEmail` | string | |
| `customerAddress` | text | |
| `customerPhone` | string (nullable) | |
| `items` | json | Snapshot des produits au moment de la commande |
| `totalAmount` | decimal(10,2) | |
| `stripeSessionId` | string | |
| `status` | string (enum: pending/paid/shipped/cancelled) | |
| `createdAt` | datetime | |
| `paidAt` | datetime (nullable) | |

- [ ] Créer `Order.php` + `OrderRepository.php`
- [ ] `OrderCrudController.php` — lecture seule pour l'admin client (pas d'édition), export CSV
- [ ] Email confirmation commande au client + notification à l'admin

### 11.4 Dashboard commandes

- [ ] Widget EasyAdmin sur le dashboard : commandes récentes, CA du mois, nombre de commandes
- [ ] Conditionné par module `ecommerce`

---

## Menu admin dynamique (vision finale)

```
┌─────────────────────────────────────────────┐
│ 📊 Tableau de bord                          │  ← Toujours visible
├─────────────────────────────────────────────┤
│ CONTENU                                     │
│   📄 Pages                                  │  ← Toujours (vitrine)
│   🔧 Services                               │  ← Si module services
│   📝 Articles                               │  ← Si module blog
│   📂 Catégories                             │  ← Si module blog
│   🏷️ Tags                                   │  ← Si module blog
│   💬 Commentaires                           │  ← Si module blog
│   📅 Événements                             │  ← Si module events
│   📦 Produits                               │  ← Si module catalogue
│   📁 Catégories produits                    │  ← Si module catalogue
│   🛒 Commandes                              │  ← Si module ecommerce
├─────────────────────────────────────────────┤
│ MÉDIAS & NAVIGATION                         │
│   🖼️ Médias                                 │  ← Toujours
│   📋 Menus                                  │  ← Toujours
├─────────────────────────────────────────────┤
│ APPARENCE (ROLE_FREELANCE+)                 │
│   🎨 Catalogue thèmes                      │
│   ⚙️ Réglages apparence                     │
│   🖼️ Images du thème                        │
├─────────────────────────────────────────────┤
│ PARAMÈTRES                                  │
│   👥 Utilisateurs                           │  ← ROLE_ADMIN+
│   🌐 Paramètres du site                    │  ← ROLE_ADMIN+
│   📦 Modules                                │  ← ROLE_FREELANCE+ (enabledModules)
└─────────────────────────────────────────────┘
```

---

## Structure cible (après toutes les phases)

```
blog_web/
├── docker/
│   ├── php/Dockerfile
│   └── nginx/default.conf
├── assets/
│   ├── app.js
│   ├── admin/
│   │   ├── tiptap-editor.js
│   │   └── tiptap-editor.scss
│   ├── controllers/                     # Stimulus controllers
│   │   ├── toc_controller.js            # Table of contents scroll spy
│   │   ├── share_controller.js          # Copy link
│   │   ├── calendar_controller.js       # Navigation calendrier
│   │   ├── gallery_controller.js        # Lightbox produits
│   │   ├── cart_controller.js           # Panier AJAX
│   │   └── product_filter_controller.js # Filtrage produits
│   └── css/base/
│       ├── variables.scss
│       ├── components.scss              # Design system partagé
│       ├── blocks.scss
│       ├── services.scss
│       ├── tags.scss
│       ├── events.scss
│       ├── products.scss
│       ├── directory.scss
│       └── ...
├── src/
│   ├── Entity/
│   │   ├── Service.php
│   │   ├── Event.php
│   │   ├── Product.php
│   │   ├── ProductCategory.php
│   │   ├── Order.php
│   │   ├── PageView.php
│   │   └── Trait/SeoTrait.php
│   ├── Enum/
│   │   ├── ModuleEnum.php
│   │   ├── VisibilityEnum.php
│   │   └── RoleEnum.php
│   ├── Controller/
│   │   ├── Admin/
│   │   │   ├── ServiceCrudController.php
│   │   │   ├── TagCrudController.php
│   │   │   ├── EventCrudController.php
│   │   │   ├── ProductCrudController.php
│   │   │   ├── ProductCategoryCrudController.php
│   │   │   └── OrderCrudController.php
│   │   ├── ServiceController.php
│   │   ├── TagController.php
│   │   ├── EventController.php
│   │   ├── ProductController.php
│   │   ├── DirectoryController.php
│   │   ├── CartController.php
│   │   ├── CheckoutController.php
│   │   └── ...
│   ├── Service/
│   │   ├── SiteContext.php
│   │   ├── ThemeService.php
│   │   ├── BlockRenderer.php
│   │   ├── CartService.php
│   │   ├── StripeService.php
│   │   ├── EventNotificationService.php
│   │   └── ArticleNotificationService.php
│   ├── Security/Voter/
│   │   └── ContentVoter.php
│   └── Model/
│       └── TenantAwareInterface.php
├── templates/
│   ├── themes/
│   │   ├── default/
│   │   ├── corporate/
│   │   ├── artisan/
│   │   ├── vitrine/
│   │   ├── starter/
│   │   └── moderne/
│   ├── _partials/
│   │   ├── _services_grid.html.twig
│   │   ├── _tag_cloud.html.twig
│   │   ├── _event_card.html.twig
│   │   ├── _calendar_widget.html.twig
│   │   ├── _product_card.html.twig
│   │   ├── _product_featured.html.twig
│   │   ├── _restricted_access.html.twig
│   │   ├── _toc.html.twig
│   │   ├── _author_card.html.twig
│   │   └── _share_bar.html.twig
│   ├── _components/
│   │   ├── _card.html.twig
│   │   ├── _badge.html.twig
│   │   ├── _pagination.html.twig
│   │   └── _empty_state.html.twig
│   ├── service/
│   ├── tag/
│   ├── event/
│   ├── product/
│   ├── directory/
│   ├── cart/
│   ├── checkout/
│   └── ...
└── ...
```

---

## Commandes utiles

### Docker

```bash
make up              # Lance tous les containers
make down            # Stop + supprime
make sh              # Shell PHP
make db              # Reset BDD : drop + create + migrate
make migrate         # Juste les migrations
make assets          # npm run dev
make assets-build    # npm run build (prod)
make cc              # Cache clear
make logs            # Logs tous services
make deploy          # (à créer) Déploiement prod
make backup          # (à créer) Backup BDD
make restore         # (à créer) Restauration BDD
```

### Accès dev

| Service | URL |
|---------|-----|
| Application | http://localhost:8080 |
| Admin | http://localhost:8080/admin |
| Mailpit | http://localhost:8025 |
| MariaDB | localhost:3307 (app/app) |
