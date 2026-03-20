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
| Phase 7 | Refonte UX Blog + Design Themes (overrides CSS, documentation, bug fixes) | ✅ |

---

## Dette technique (héritée de CLAUDE.md) ✅

> Soldée. Les items restants sont soit faits, soit reportés au déploiement serveur.

### DT.1 — Docker production → reporté au déploiement
### DT.2 — Performance → corrigé (eager loading menus, régénération WebP)
### DT.3 — Corrections mineures → corrigé (typos, abonnements, vérification email)
### DT.4 — Affinements CSS → corrigé (Phase 5 itérations)
### DT.5 — Sécurité production → config serveur au déploiement (Fail2ban, SSL, backups, CSP)

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

## Phase 7 — Refonte UX Blog + Design Themes ✅

> Temps réel : ~2 jours (réparti sur Phases 4-5 + session design)

### 7.1 Page /articles (blog listing) ✅

- [x] Header de page : titre "Blog", compteur total articles (`blog-header`)
- [x] Article featured : `isFeatured` (boolean) sur `Article` + `ArticleRepository::findFeatured()` + card large pleine largeur (`blog-featured`)
- [x] Grille articles : `blog-grid` 2 colonnes desktop / 1 mobile
- [x] Card article complète (`blog-card`) : image 16:9, badge catégorie, titre clamp 2 lignes, extrait clamp 3, meta date + lecture + tags, hover translateY + shadow
- [x] Filtrage par catégorie : pills horizontales scrollables (`blog-filters__pill`), filtre serveur `?categorie=slug`
- [x] Filtrage par tag : nuage de tags en sidebar
- [x] Pagination Doctrine + style Bootstrap customisé
- [x] `article_list.scss` complet (~357 lignes)
- [x] `blog.html.twig` custom dans chaque thème (6 thèmes)

### 7.2 Page /article/{slug} (article show) ✅

- [x] Layout lecture optimisé : colonne contenu (`col-lg-7`) + sidebar sticky (`col-lg-4`) + share sticky (`col-lg-1`)
- [x] Image featured hero : `responsive_img` avec srcset
- [x] Meta header : badges catégorie + date + temps de lecture (`readingTime` filter)
- [x] Sommaire auto (TOC) : `toc_extract()` + `toc_anchors` filter, widget sidebar sticky, Stimulus `toc` controller avec scroll spy
- [x] Tags cliquables sous le contenu → `/tag/{slug}`
- [x] Bloc auteur : card avec avatar et bio
- [x] Articles connexes : `findRelated()` → grille 3 colonnes
- [x] Boutons partage : barre sticky gauche (desktop) + barre fixe bas (mobile) — Facebook, Twitter, LinkedIn, copier lien
- [x] Commentaires : cards avec auteur + date, formulaire conditionnel (connecté)
- [x] `article.scss` complet

### 7.3 Design Themes — Overrides par thème ✅

Chaque `theme.css` contient des overrides complets pour toutes les pages globales :

- [x] **Article show** : titres (serif/sans), blockquote, badges, tags, share buttons, comments, author card, TOC
- [x] **Blog listing** : cards (radius, hover, layout), featured, filters, header, pagination
- [x] **Page show** : hero, titre, blockquote
- [x] **Widgets** : sidebar cards, register, tag pills
- [x] **Home articles** : cards dans les sections derniers articles de chaque thème
- [x] **Starter** : layout radical (pas de sidebar, pas de share, liste linéaire, 640px max)
- [x] **Moderne** : dark mode complet (inputs, forms, pagination, breadcrumbs, empty state)

### 7.4 Documentation design ✅

- [x] `DESIGN_THEME.md` : document d'architecture global (variables, règles, patterns)
- [x] 6 fichiers `templates/themes/{slug}/DESIGN.md` : specs visuelles détaillées par thème

### 7.5 Bug fixes session design ✅

- [x] Comment date format : `\u00e0` cassait `date()` → split en deux appels séparés
- [x] Contact rate limiter : `#[Autowire(service: 'limiter.contact_limiter')]` pour autowiring
- [x] Theme fonts : `|raw` sur les variables font-family dans `base.html.twig` (empêchait l'autoescaping des quotes)
- [x] Theme variables prefix : ajout conditionnel `--` dans la boucle Twig theme_vars
- [x] SCSS vs inline priority : suppression des variables thème dans `variables.scss` pour éviter l'écrasement des inline styles

### 7.6 Couleurs dynamiques + Responsive tablette ✅

- [x] **Couleurs dérivées dynamiques** : `--primary-light`, `--primary-dark`, `--secondary-light`, `--accent-light`, `--surface-alt` passées de valeurs SCSS hardcodées à `color-mix()` CSS natif → s'adaptent automatiquement à chaque thème
- [x] **Gradient warm dynamique** : `--gradient-warm` utilise `color-mix()` au lieu d'un orange hardcodé
- [x] **Fonts héritées du thème** : `--font-display` hérite de `--font-family-secondary` (puis `--font-family`), `--font-body` hérite de `--font-family` — plus de 'Inter' hardcodé
- [x] **TOC widget** : `position: static` en dessous de 992px (évite chevauchement tablette/mobile)
- [x] **Blog grid** : gap réduit à 1rem en tablette ; grid 3-col → 2-col dès 992px
- [x] **Featured article** : aspect-ratio 21:9 → 16:9 dès 992px (au lieu de 768px)
- [x] **Hero section** : padding réduit 5rem → 4rem en tablette
- [x] **Features section** : padding réduit 5rem → 3.5rem en tablette
- [x] **CTA section** : padding réduit 5rem → 3.5rem en tablette
- [ ] `_components/_card.html.twig` — macro Twig card réutilisable (reporté, cards déjà factorisées via `article/item.html.twig`)

**Fichiers modifiés (4) :** `variables.scss`, `toc.scss`, `article_list.scss`, `home.scss`

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

## Phase 12 — Navigation, Pages légales & Menus

> Temps estimé : ~1.5 jours
> Prérequis : toutes les phases précédentes (pour avoir la liste complète des entrées de menu possibles)

**Pourquoi en dernier ?** À ce stade, tous les modules existent (blog, services, événements, catalogue, boutique). On peut construire un système de menu qui couvre tous les cas, avec les bonnes liaisons.

### 12.1 Refonte entité Menu

**Problème actuel** : une seule entité Menu plate, pas de zones, pas de sous-menus structurés, liens manuels fragiles.

**Nouvelle structure :**

| Champ | Type | Notes |
|-------|------|-------|
| `id` | int (auto) | PK |
| `label` | string(255) | Texte affiché |
| `zone` | string (enum: `header`, `footer`, `legal`) | Zone d'affichage |
| `type` | string (enum) | `page`, `article_list`, `service_list`, `event_list`, `product_list`, `category`, `external`, `home`, `contact` |
| `targetPage` | ManyToOne Page (nullable) | Si type = `page` |
| `targetCategory` | ManyToOne Categorie (nullable) | Si type = `category` |
| `externalUrl` | string(255, nullable) | Si type = `external` |
| `parent` | ManyToOne Menu (nullable, self-ref) | Sous-menus |
| `position` | integer (default 0) | Ordre |
| `isVisible` | boolean (default true) | |
| `linkedModule` | string (nullable) | Slug module → auto-masqué si module désactivé |
| `cssClass` | string(100, nullable) | Classe CSS custom (optionnel) |
| `openInNewTab` | boolean (default false) | Target blank |

- [ ] Refondre `src/Entity/Menu.php` avec les champs ci-dessus
- [ ] Créer `src/Enum/MenuZoneEnum.php` — `header`, `footer`, `legal`
- [ ] Créer `src/Enum/MenuTypeEnum.php` — `home`, `page`, `article_list`, `service_list`, `event_list`, `product_list`, `category`, `contact`, `external`
- [ ] `MenuRepository` : `findByZone(string $zone)` avec tri position, filtre module actif + isVisible, eager load children
- [ ] Migration Doctrine (attention : migration de données depuis l'ancien schéma)

**Logique `linkedModule`** : quand `type = article_list` → `linkedModule = 'blog'`, `type = service_list` → `linkedModule = 'services'`, etc. Le repository filtre automatiquement les entrées dont le module est désactivé.

**Génération d'URL par type :**
```php
match($menu->getType()) {
    'home' => path('app_home'),
    'page' => path('app_page_show', ['slug' => $menu->getTargetPage()->getSlug()]),
    'article_list' => path('app_article_show_all'),
    'service_list' => path('app_service_index'),
    'event_list' => path('app_event_index'),
    'product_list' => path('app_product_index'),
    'category' => path('app_categorie_show', ['slug' => $menu->getTargetCategory()->getSlug()]),
    'contact' => path('app_contact'),
    'external' => $menu->getExternalUrl(),
}
```

### 12.2 Pages légales (système)

**Objectif** : mentions légales, politique cookies, CGV sont des pages obligatoires, pré-créées, éditables mais non supprimables.

- [ ] Ajouter `isSystem` (boolean, default false) sur `Page` — les pages système ne peuvent pas être supprimées
- [ ] Ajouter `systemSlug` (string nullable, unique) sur `Page` — identifiant technique (`mentions-legales`, `cookies`, `cgv`)
- [ ] `app:init-site` : créer automatiquement les 3 pages légales avec contenu template pré-rempli :
  - `mentions-legales` — Mentions légales (contenu type avec placeholders nom, adresse, SIRET)
  - `politique-cookies` — Politique de cookies (contenu RGPD standard)
  - `cgv` — Conditions Générales de Vente (contenu si module ecommerce actif, sinon non créée)
- [ ] `PageCrudController` : masquer le bouton "Supprimer" sur les pages système (`configureActions` conditionnel)
- [ ] Template dédié `templates/page/legal.html.twig` — layout épuré (pas de sidebar, pas d'image hero, juste le contenu centré)
- [ ] Les pages légales utilisent le template `legal` automatiquement (détecté via `isSystem`)

### 12.3 Admin Navigation (refonte)

- [ ] Refondre `MenuCrudController` / page admin Navigation :
  - Vue par zone : onglets "Header" | "Footer" | "Légal"
  - Drag & drop pour réordonner (Stimulus `sortable_controller.js`)
  - Formulaire : label, type (dropdown dynamique), cible (selon type), zone, parent (sous-menu), options (new tab, CSS class)
  - Preview en temps réel du menu (mini-rendu HTML)
- [ ] Boutons rapides : "Ajouter Accueil", "Ajouter Blog", "Ajouter Services" — pré-remplis selon modules actifs
- [ ] Validation : empêcher les liens vers des modules désactivés

### 12.4 Intégration thèmes

**Objectif** : chaque thème consomme les menus par zone, pas en dur.

- [ ] `MenuService` (ou extension Twig) : `getMenusByZone('header')`, `getMenusByZone('footer')`, `getMenusByZone('legal')`
- [ ] Chaque `_header.html.twig` de thème : boucle sur `menus_header` au lieu de requête brute
  - Sous-menus : dropdown Bootstrap (desktop) / accordion (mobile)
  - Liens auto-générés via `MenuTypeEnum` → pas de `href="#"` en dur
- [ ] Chaque `_footer.html.twig` de thème :
  - Colonne "Navigation" → `menus_footer`
  - Colonne "Légal" → `menus_legal` (mentions, cookies, CGV)
  - Colonne "Contact" → infos depuis `Site` (adresse, téléphone, email)
  - Liens sociaux → depuis `Site` (déjà existants)
- [ ] Fallback : si aucun menu n'est configuré → menu par défaut généré depuis les modules actifs

### 12.5 Bandeau cookies (RGPD)

- [ ] Stimulus `cookie_consent_controller.js` :
  - Bandeau non-intrusif en bas de page (pas de modal bloquant)
  - 3 boutons : "Accepter tout", "Refuser", "Personnaliser"
  - Stockage `localStorage` (pas de cookie pour stocker le consentement = ironie)
  - Si Google Analytics configuré → ne charge le script que si consent donné
- [ ] Template `_partials/_cookie_banner.html.twig` — inclus dans `base.html.twig`
- [ ] Lien vers la page "Politique de cookies" dans le bandeau
- [ ] SCSS : `cookie_banner.scss`

**Fichiers créés :** `MenuZoneEnum.php`, `MenuTypeEnum.php`, `MenuService.php`, `page/legal.html.twig`, `_cookie_banner.html.twig`, `cookie_consent_controller.js`, `sortable_controller.js`, `cookie_banner.scss`
**Fichiers modifiés :** `Menu.php`, `MenuRepository.php`, `Page.php`, `PageCrudController.php`, `MenuCrudController.php`, `DashboardController.php`, `InitSiteCommand.php`, `base.html.twig`, 6× `_header.html.twig`, 6× `_footer.html.twig`
**Migrations :** oui (Menu refonte + Page.isSystem + Page.systemSlug)

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
