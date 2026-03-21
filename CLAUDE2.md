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
| Phase 8 | Module Événements (entité Event, CRUD admin, front, sidebar, notifications, CSS) | ✅ |

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

## Phase 8 — Module Événements / Calendrier ✅

> Temps réel : ~1 jour
> Prérequis : Phase 6.1 (enabledModules)

### 8.1 Entité Event + Repository + Migration ✅

- [x] `src/Entity/Event.php` — title, slug (unique), shortDescription, blocks (JSON), content (TEXT cache), dateStart, dateEnd (nullable), location, image (FK Media nullable), isActive, isFeatured, `use SeoTrait;`
- [x] Virtual `getBlocksJson()`/`setBlocksJson()` — même pattern que Service/Article
- [x] Helpers : `isUpcoming()`, `isPast()`, `isMultiDay()`
- [x] Index sur `is_active`, `date_start`, `is_featured`
- [x] `src/Repository/EventRepository.php` :
  - `findUpcoming(int $limit)` — événements futurs, triés dateStart ASC
  - `findPast(int $limit, int $offset)` — événements passés, paginés DESC
  - `countPast()` — pour pagination
  - `findByMonth(int $year, int $month)` — pour widget
  - `findOneActiveBySlug(string $slug)`
  - `findAllActiveForSitemap()` — filtre noIndex=false
  - `findFeatured()` — upcoming + featured
- [x] Migration `Version20260320173148.php` — table Event

### 8.2 CRUD Admin ✅

- [x] `src/Controller/Admin/EventCrudController.php` (`#[IsGranted('ROLE_ADMIN')]`) :
  - 4 panels : "Contenu" (title, shortDescription, blocksJson TipTap, image) | "Date & Lieu" (dateStart, dateEnd, location) | "SEO" (5 champs SeoTrait) | "Paramètres" (slug, isActive, isFeatured)
  - Index : title, dateStart, location, isActive (toggle), isFeatured
  - Tri default : dateStart DESC
- [x] `DashboardController` : menu "Événements" conditionné par `hasModule('events')` + `ROLE_ADMIN`
- [x] `EventNotificationService` injecté : notification aux abonnés quand event publié (persistEntity/updateEntity)

### 8.3 Front ✅

- [x] `src/Controller/EventController.php` :
  - `GET /evenements` — index avec upcoming (tous) + past (paginés, 10 par page)
  - `GET /evenement/{slug}` — détail avec sidebar
  - Guard `hasModule('events')` → 404 si désactivé
  - SEO via `SeoService`
- [x] `templates/event/index.html.twig` — sections "À venir" / "Événements passés", pagination, état vide (SVG calendrier)
- [x] `templates/event/show.html.twig` — layout col-lg-8 (contenu) + col-lg-4 (sidebar) :
  - Header : date badge, titre h1, meta (date/lieu/badge statut), image, lead, contenu TipTap, bouton retour
  - Sidebar : widget infos pratiques (date, horaires, lieu), widget s'abonner (3 états : non connecté, connecté non abonné, connecté abonné), widget prochains événements
- [x] `templates/_partials/_event_card.html.twig` — card réutilisable (image, date badge jour/mois, titre, lieu, extrait tronqué, horaires, badge "Terminé")
- [x] `templates/_partials/_upcoming_events_widget.html.twig` — widget sidebar liste compacte (date + titre + lieu, lien "Voir tous →")
- [x] Widget "Prochains événements" dans `WidgetService::findUpcomingEvents()`
- [x] Section événements sur homepage default (`themes/default/home.html.twig`) : grille 3 colonnes, conditionnée par `upcomingEvents|length > 0`

### 8.4 Abonnements / Alertes événements ✅

- [x] `subscribeEvents` (boolean, default false) ajouté sur `User` + migration `Version20260321055237.php`
- [x] `src/Service/EventNotificationService.php` — email Brevo aux users avec `subscribeEvents = true` (pattern ArticleNotificationService)
- [x] Câblé dans `EventCrudController::persistEntity()` / `updateEntity()`
- [ ] Page profil utilisateur : checkbox `subscribeEvents` (à ajouter au formulaire profil)

### 8.5 Sitemap + ContentSanitizeListener ✅

- [x] `SitemapController` : events ajoutés (priority 0.6, weekly, conditionné par module)
- [x] `sitemap/index.xml.twig` : boucle events
- [x] `ContentSanitizeListener` : Event ajouté (compile blocks → content HTML)
- [x] `HomeController` : passe `upcomingEvents` si module events actif

### 8.6 CSS ✅

- [x] `assets/css/base/events.scss` (~614 lignes) — 100% CSS custom properties, compatible 6 thèmes :
  - `.events-section` — titre page index
  - `.events-grid` — grille responsive (2 cols → 1 col mobile, 3 cols home)
  - `.event-card` — card complète (hover translateY + shadow, image zoom, date badge `color-mix()`, badge "Terminé")
  - `.events-empty` — état vide (SVG + message)
  - `.event-detail` — page détail (header flex, date badge large, meta items, image, lead, content, back, responsive mobile)
  - `.home-events` — section homepage
  - `.widget-events` — widget sidebar "Prochains événements"
  - `.widget-event-info` — widget sidebar "Infos pratiques"
  - `.widget-event-subscribe` — widget sidebar "S'abonner aux événements"
- [x] Import dans `main.scss`

### Décision de design

- **Widget calendrier** : choix "Liste simple" (pas de calendrier interactif) — plus simple, suffisant pour le cas d'usage
- **Intégration thèmes** : Option A retenue — terminer tous les modules d'abord, puis construire un système de sections configurables (voir Phase 13)

**Fichiers créés (9) :** `Event.php`, `EventRepository.php`, `EventCrudController.php`, `EventController.php`, `EventNotificationService.php`, `event/index.html.twig`, `event/show.html.twig`, `_event_card.html.twig`, `_upcoming_events_widget.html.twig`, `events.scss`
**Fichiers modifiés (9) :** `User.php`, `DashboardController.php`, `HomeController.php`, `SitemapController.php`, `sitemap/index.xml.twig`, `ContentSanitizeListener.php`, `WidgetService.php`, `themes/default/home.html.twig`, `main.scss`
**Migrations (2) :** `Version20260320173148.php` (Event), `Version20260321055237.php` (User.subscribeEvents)

### Reste à faire (Phase 8)

- [ ] Ajouter checkbox `subscribeEvents` dans le formulaire profil utilisateur
- [ ] Intégrer section événements dans les 5 autres thèmes (corporate, artisan, vitrine, starter, moderne) — reporté à Phase 13

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

## Phase 13 — Sections Configurables Home & Sidebar

> Temps estimé : ~2 jours
> Prérequis : Phases 8-12 terminées (tous les modules existent)
> Décision : Option A — construire le système configurable après avoir terminé tous les modules

### Contexte

Actuellement, chaque thème a sa propre `home.html.twig` avec les sections en dur (hero, services, articles, événements, etc.). La sidebar est aussi fixe dans chaque template. Cela pose deux problèmes :
1. Ajouter un module nécessite de modifier les 6 fichiers `home.html.twig` de chaque thème
2. Le client/freelance ne peut pas réorganiser les sections de la homepage ni de la sidebar

### 13.1 Modèle de données

**Ajouter sur l'entité `Site` :**

| Champ | Type | Notes |
|-------|------|-------|
| `homeSections` | json | Liste ordonnée des sections homepage |
| `sidebarSections` | json | Liste ordonnée des widgets sidebar |

**Format JSON `homeSections` :**
```json
[
  { "type": "hero", "enabled": true },
  { "type": "services", "enabled": true, "limit": 6 },
  { "type": "articles", "enabled": true, "limit": 3 },
  { "type": "events", "enabled": true, "limit": 3 },
  { "type": "products_featured", "enabled": false, "limit": 4 },
  { "type": "metrics", "enabled": true },
  { "type": "cta", "enabled": true }
]
```

**Format JSON `sidebarSections` :**
```json
[
  { "type": "search", "enabled": true },
  { "type": "categories", "enabled": true },
  { "type": "tag_cloud", "enabled": true },
  { "type": "upcoming_events", "enabled": true, "limit": 3 },
  { "type": "subscribe", "enabled": true },
  { "type": "archives", "enabled": true }
]
```

- Chaque section a un `type` (identifiant unique) et `enabled` (toggle)
- Les sections liées à un module sont auto-masquées si le module est désactivé
- Les sections peuvent avoir des options (`limit`, etc.)
- L'ordre du tableau JSON = l'ordre d'affichage

### 13.2 SectionService

- [ ] Créer `src/Service/SectionService.php` :
  - `getHomeSections(): array` — résout les sections homepage (filtre modules désactivés, merge avec defaults)
  - `getSidebarSections(): array` — idem pour sidebar
  - `getDefaultHomeSections(): array` — sections par défaut selon modules activés
  - `getDefaultSidebarSections(): array` — idem sidebar
  - `getAvailableSectionTypes(string $zone): array` — liste tous les types possibles avec label/description/module requis

**Mapping section → module :**
```php
'services' => 'services',
'articles' => 'blog',
'events' => 'events',
'products_featured' => 'catalogue',
'categories' => 'blog',
'tag_cloud' => 'blog',
'upcoming_events' => 'events',
'archives' => 'blog',
```

Sections sans module (toujours disponibles) : `hero`, `metrics`, `cta`, `search`, `subscribe`

### 13.3 Partials Twig

**Découper chaque section en partial réutilisable :**

```
templates/_sections/
├── home/
│   ├── _hero.html.twig
│   ├── _services.html.twig
│   ├── _articles.html.twig
│   ├── _events.html.twig
│   ├── _products_featured.html.twig
│   ├── _metrics.html.twig
│   └── _cta.html.twig
└── sidebar/
    ├── _search.html.twig
    ├── _categories.html.twig
    ├── _tag_cloud.html.twig
    ├── _upcoming_events.html.twig
    ├── _subscribe.html.twig
    └── _archives.html.twig
```

**Chaque partial reçoit ses données via le controller** (pas de requête Twig) et est autonome.

### 13.4 Intégration thèmes

**Transformer `home.html.twig` de chaque thème :**

```twig
{# Avant (sections hardcodées) #}
{% include 'themes/default/_hero.html.twig' %}
{% include '_partials/_services_grid.html.twig' %}
...

{# Après (sections dynamiques) #}
{% for section in homeSections %}
  {% if section.enabled %}
    {% include ['themes/' ~ _theme ~ '/_sections/' ~ section.type ~ '.html.twig',
                '_sections/home/_' ~ section.type ~ '.html.twig']
       with { config: section } %}
  {% endif %}
{% endfor %}
```

**Avantages :**
- Chaque thème peut override une section spécifique (fallback vers le partial commun)
- Ajouter un nouveau module = ajouter un partial, sans toucher aux thèmes
- Le FREELANCE/SUPER_ADMIN réordonne les sections dans l'admin

### 13.5 Admin Sections

- [ ] Créer page admin "Sections" (`ROLE_FREELANCE+`) :
  - 2 onglets : "Homepage" | "Sidebar"
  - Liste drag & drop (Stimulus `sortable_controller.js`) des sections
  - Toggle enabled/disabled par section
  - Options par section (limit, etc.) via formulaire inline
  - Bouton "Réinitialiser" (remet les defaults du thème)
- [ ] Preview en temps réel via iframe
- [ ] Menu admin : ajout dans section "Apparence"

### 13.6 Controller updates

- [ ] `HomeController` : passe les données de toutes les sections activées
- [ ] Créer `SidebarDataProvider` ou enrichir `WidgetService` pour fournir les données sidebar selon les sections activées
- [ ] Migration Doctrine (Site.homeSections, Site.sidebarSections)

**Fichiers créés :** `SectionService.php`, `_sections/home/*.html.twig` (7), `_sections/sidebar/*.html.twig` (6), admin template sections
**Fichiers modifiés :** `Site.php`, `HomeController.php`, `WidgetService.php`, 6× `home.html.twig` thèmes, `DashboardController.php`
**Migration :** oui (Site.homeSections + Site.sidebarSections)

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
