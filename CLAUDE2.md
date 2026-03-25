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
| Phase 9 | Pages Privées / Contenu Restreint (VisibilityEnum 4 niveaux, ContentVoter, Annuaire membres) | ✅ |

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

## Phase 9 — Pages Privées / Contenu Restreint ✅

> Temps réel : ~0.5 jour
> Prérequis : Phase 6.1 (enabledModules)

### 9.1 Visibilité sur les contenus ✅

- [x] `src/Enum/VisibilityEnum.php` — enum string-backed 4 niveaux (public, user, author, admin) avec `label()`, `requiredRole()`, `choices()`
- [x] Champ `visibility` (string, default 'public') ajouté sur `Page` et `Article` + migration `Version20260321064455.php`
- [x] `src/Security/Voter/ContentVoter.php` — vérifie le rôle vs la visibilité via `RoleHierarchyInterface` (respecte la hiérarchie configurée dans `security.yaml`)
- [x] `PageRepository` : `findAllPublishedForSitemap()` filtre `visibility = 'public'` (sitemap n'expose pas les pages privées)
- [x] `MenuService` : filtre automatique des menus liés à du contenu restreint (vérifie `page.visibility` et `article.visibility`, masque les entrées si le user n'a pas le rôle requis)
- [x] `AppExtension` : filtre Twig `menuVisible` ajouté (utilisable dans les templates si besoin)
- [x] Admin `PageCrudController` : `ChoiceField::new('visibility')` — visible uniquement si module `private_pages` activé, avec help text explicatif
- [x] Admin `ArticleCrudController` : idem, `ChoiceField` conditionné par module `private_pages`

### 9.2 UX page restreinte ✅

- [x] `templates/_partials/_restricted_access.html.twig` :
  - Icône cadenas SVG, titre "Contenu restreint"
  - Message adapté selon visibilité (user → "réservée aux membres", author → "réservée aux auteurs", admin → "réservée aux administrateurs")
  - Boutons "Se connecter" / "Créer un compte" si non connecté
  - Message "droits insuffisants" si connecté mais pas autorisé
  - Lien "Retour à l'accueil"
  - Conserve header/footer du site (extends `base.html.twig`, pas de 403 brut)
- [x] `PageController::show()` : réécrit — si accès refusé par ContentVoter, render restricted_access avec Response 403
- [x] `ArticleController::show()` : même logique voter + restricted_access
- [x] `assets/css/base/restricted.scss` — styles adaptatifs via CSS custom properties (compatible 6 thèmes)

### 9.3 Annuaire membres (sous-module directory) ✅

- [x] Champs ajoutés sur `User` : `company` (string nullable), `jobTitle` (string nullable), `phone` (string nullable), `isDirectoryVisible` (boolean, default false) + migration
- [x] `src/Controller/DirectoryController.php` :
  - `GET /annuaire` — liste des users avec `isDirectoryVisible = true`
  - Recherche par nom, prénom, entreprise, poste (paramètre `?q=`)
  - Guard `hasModule('directory')` + `#[IsGranted('ROLE_USER')]`
  - SEO via `SeoService`
- [x] `src/Repository/UserRepository.php` :
  - `findDirectoryMembers(string $search)` — filtre `isDirectoryVisible`, recherche LIKE multi-champs
  - `findSubscribersForEvents()` — pour les notifications événements
- [x] `templates/directory/index.html.twig` :
  - Header titre + sous-titre
  - Barre de recherche centrée
  - Grille 3 colonnes (responsive 2→1) de cards membres
  - Card : avatar (image ou placeholder initiales), nom, poste, entreprise (icône), bio tronquée
  - État vide avec SVG et message adapté (recherche vs aucun membre)
  - Compteur de résultats
- [x] `assets/css/base/directory.scss` — 100% CSS custom properties (compatible 6 thèmes) :
  - `.directory-grid` responsive, `.member-card` avec hover, `.member-avatar-placeholder` avec `color-mix()`
- [x] Admin `UserCrudController` : champs `isDirectoryVisible`, `company`, `jobTitle`, `phone` — conditionnés par module `directory`

**Fichiers créés (6) :** `VisibilityEnum.php`, `ContentVoter.php`, `_restricted_access.html.twig`, `DirectoryController.php`, `directory/index.html.twig`, `restricted.scss`, `directory.scss`
**Fichiers modifiés (10) :** `Page.php`, `Article.php`, `User.php`, `PageRepository.php`, `UserRepository.php`, `PageController.php`, `ArticleController.php`, `PageCrudController.php`, `ArticleCrudController.php`, `UserCrudController.php`, `MenuService.php`, `AppExtension.php`, `main.scss`
**Migration :** `Version20260321064455.php` (Page.visibility, Article.visibility, User.company/jobTitle/phone/isDirectoryVisible)

---

## Phase 10 — Catalogue Produits ✅

> Réalisé en ~1 jour
> Prérequis : Phase 6.1 (enabledModules), Phase 7.3 (composants partagés)

### Vision

Catalogue vitrine pour petits pros : artisan qui montre ses créations, gîte qui présente ses chambres, guide de pêche qui affiche ses formules, formateur ses sessions. Pas un site e-commerce — une vitrine produits/prestations avec prix. Le module `ecommerce` (Phase 11) ajoute le paiement par-dessus si besoin.

### 10.1 Entités ✅

**`ProductCategory`** : name, slug (unique), description, image (FK Media), position, isActive

**`Product`** : title, slug (unique), shortDescription, blocks (JSON TipTap), content (HTML cache), priceHT (decimal nullable), oldPriceHT (decimal nullable), vatRate (decimal default 20.00), availability (enum), category (FK ProductCategory), tags (M2M Tag), image (FK Media), relatedProducts (M2M self-ref), bookingUrl, bookingLabel, isActive, isFeatured, position + `use SeoTrait;`

**Getters calculés :** `getPriceTTC()`, `getOldPriceTTC()`, `getVatAmount()`, `isOnSale()`, `isOnRequest()`

**`ProductImage`** (table pivot ordonnée) : product (FK), media (FK), position

**`ProductVariant`** : product (FK), label, priceHT (nullable = hérite du produit), oldPriceHT, position, isActive

**`AvailabilityEnum`** : `AVAILABLE` ("Disponible"), `UNAVAILABLE` ("Indisponible"), `ON_REQUEST` ("Sur devis")

**Réglage Site :** `catalogDisplayHT` (boolean, default false) — `isCatalogDisplayHT()` contrôle l'affichage front (B2B = HT, B2C = TTC)

- [x] Créer `src/Entity/Product.php`
- [x] Créer `src/Entity/ProductCategory.php`
- [x] Créer `src/Entity/ProductImage.php`
- [x] Créer `src/Entity/ProductVariant.php`
- [x] Créer `src/Enum/AvailabilityEnum.php`
- [x] Ajouter `catalogDisplayHT` sur `Site.php`
- [x] Créer repositories : `ProductRepository` (`findAllActive()`, `findByCategory()`, `findFeatured()`, `findForSitemap()`, `findRelated()`), `ProductCategoryRepository`, `ProductImageRepository`, `ProductVariantRepository`
- [x] `ContentSanitizeListener` : ajouter Product (compile blocks → content)
- [x] Migrations Doctrine (`Version20260321154700.php`)

### 10.2 Admin ✅

- [x] `ProductCategoryCrudController.php` — liste triable par position, formulaire (name, slug auto, description, image, isActive)
- [x] `ProductCrudController.php` :
  - 7 panels : Contenu | Galerie photos (CollectionField inline) | Tarifs (priceHT, oldPriceHT, vatRate dropdown, availability) | Variantes (CollectionField inline) | Réservation/RDV (bookingUrl, bookingLabel) | Classification (tags, relatedProducts) | SEO (5 champs) | Paramètres (slug, isActive, isFeatured, position)
  - Liste : title, category, priceHT, availability (formatValue label), priceTTC (NumberField calculé), isActive toggle, isFeatured toggle
  - Filtres : EntityFilter category, ChoiceFilter availability, BooleanFilter isActive/isFeatured
- [x] `ProductImageCrudController.php` — formulaire inline pour CollectionField galerie
- [x] `ProductVariantCrudController.php` — formulaire inline pour CollectionField variantes
- [x] `SiteCrudController` : `catalogDisplayHT` conditionné par module `catalogue`
- [x] Menu admin conditionné par module `catalogue` : "Produits" + "Categories produits"
- [x] Affichage prix TTC calculé en index (lecture seule, `NumberField::formatValue`)

**Bugs corrigés en admin :**
- AvailabilityEnum : ChoiceField avec enum cases directement (pas `::choices()` string) + `formatValue()` pour labels FR
- priceTTC : `NumberField` au lieu de `TextField` (évite erreur conversion float→string)
- `renderAsBadges()` retiré (crash avec enum keys)
- Position nullable (`?int`) sur Product et ProductVariant — évite crash EasyAdmin PropertyAccessor
- Upload galerie : `ImageField` remplacé par `FileType` Symfony standard (l'`ImageField` ne fonctionne pas dans `CollectionField::useEntryCrudForm()`)
- `ProductCrudController::processGalleryUploads()` — déplace le fichier, crée le `Media`, génère WebP via `MediaProcessorService`
- Auto-affectation image principale : si aucune image principale et galerie non vide, la 1re image galerie est affectée automatiquement à la sauvegarde
- `ProductImage.uploadFile` : propriété non persistée (`UploadedFile`), plus de colonne DB

### 10.3 Front ✅

- [x] `ProductController.php` — 3 routes :
  - `GET /catalogue` — grille avec sidebar (catégories + tri position/prix)
  - `GET /catalogue/categorie/{slug}` — filtre par catégorie
  - `GET /catalogue/{slug}` — fiche produit détail
  - Guard `hasModule('catalogue')` → 404 si désactivé
  - SEO via `SeoService`
- [x] Templates :
  - `product/index.html.twig` — grille responsive + sidebar catégories/tri + empty state SVG
  - `product/show.html.twig` — fiche détail complète :
    - Galerie images avec lightbox (Stimulus `product_gallery_controller.js`)
    - Prix HT/TTC avec prix secondaire et taux TVA
    - Sélecteur variantes (Stimulus `product_variant_controller.js`)
    - Badge disponibilité (vert/rouge/orange)
    - CTA dynamique : bookingUrl → on_request contact → available contact → disabled
    - Description TipTap (`product.content|raw`)
    - Produits associés en grille
  - `_partials/_product_card.html.twig` — card réutilisable (image/placeholder, badges promo/indispo, catégorie, prix)
  - `_partials/_product_featured.html.twig` — widget homepage "Nos produits" + lien "Voir tout le catalogue"
- [x] Stimulus controllers :
  - `product_gallery_controller.js` — lightbox, navigation clavier (Escape, flèches), thumbnails
  - `product_variant_controller.js` — sélection variante, mise à jour prix dynamique HT/TTC
- [x] Intégration recherche : `SearchController` enrichi (dropdown JSON + page HTML) pour produits si module `catalogue` actif
- [x] Sitemap : produits ajoutés avec priorité 0.7, changefreq weekly
- [x] Homepage : widget produits featured ajouté sur les 6 thèmes (default, corporate, artisan, vitrine, starter, moderne)
- [x] SCSS : `products.scss` — styles complets avec CSS custom properties uniquement (grille, cards, galerie, lightbox, variantes, badges, responsive 991px/575px)
- [x] Fallback image : fiche produit et cards catalogue utilisent la 1re image galerie si pas d'image principale
- [x] Catégories dynamiques : variable Twig renommée `productCategories` pour éviter conflit avec `categories` de `base.html.twig`
- [x] Thumbnails galerie : affichées uniquement si >1 image, première thumb active automatiquement

**Vérifié sur les 6 thèmes via Chrome :** catalogue index, fiche produit détail, widget homepage — les CSS custom properties s'adaptent automatiquement à chaque thème (dark mode moderne inclus).

**Fichiers créés (20) :** `Product.php`, `ProductCategory.php`, `ProductImage.php`, `ProductVariant.php`, `AvailabilityEnum.php`, `VisibilityEnum.php`, `ProductRepository.php`, `ProductCategoryRepository.php`, `ProductImageRepository.php`, `ProductVariantRepository.php`, `ProductCrudController.php`, `ProductCategoryCrudController.php`, `ProductImageCrudController.php`, `ProductVariantCrudController.php`, `ProductController.php`, `product/index.html.twig`, `product/show.html.twig`, `_product_card.html.twig`, `_product_featured.html.twig`, `product_gallery_controller.js`, `product_variant_controller.js`, `products.scss`
**Fichiers modifiés (12) :** `Site.php`, `ContentSanitizeListener.php`, `SitemapController.php`, `sitemap/index.xml.twig`, `SearchController.php`, `search/results.html.twig`, `HomeController.php`, `DashboardController.php`, `SiteCrudController.php`, `main.scss`, + 6 `home.html.twig` (tous les thèmes)
**Migrations :** `Version20260321154700.php` (Product, ProductCategory, ProductImage, ProductVariant, Site.catalogDisplayHT), `Version20260322055518.php` (ProductImage.media nullable), `Version20260322061559.php` (drop ProductImage.upload_file)

---

## Phase 11 — Boutique / Paiement ✅

> Prérequis : Phase 10 (catalogue), Phase 8 (événements)
> Module : `ecommerce` (activable indépendamment du catalogue pur)

### Vision

E-commerce light pour tous les profils : asso qui vend des cotisations/places, artisan qui vend ses créations, guide qui vend ses sorties, formateur ses sessions, commerce sa vitrine. Panier multi-items, pas de gestion de stock, pas d'expédition, pas de retours.

**Checkout sans compte :** pas de création de compte, pas de login. Le client remplit un formulaire simple (prénom, nom, email, téléphone, message optionnel) et commande directement. L'admin récupère les coordonnées dans chaque commande.

**2 moyens de paiement :**
- **Stripe Checkout** (redirect) — carte bancaire, zéro PCI-DSS côté serveur
- **Paiement manuel** — commande enregistrée, l'admin valide à réception (virement, chèque, espèces)

> Si les clés Stripe ne sont pas configurées, seul le paiement manuel est proposé.

**Liaison Event ↔ Product :** un événement peut être lié à un produit du catalogue. L'inscription/paiement passe par le panier existant — pas de duplication de logique.

**Config Stripe dans l'admin :** les clés Stripe (publique, secrète, webhook secret) sont configurables depuis l'admin (panel "Paiement Stripe" dans Identité du site, visible `ROLE_FREELANCE+`). Fallback sur `.env` si vide dans l'admin.

### 11.1 Panier ✅

- [x] `CartService.php` — panier en session Symfony : add, remove, update, clear, getItems, getTotalHT/TTC/VAT, getCount, isEmpty, buildOrderItems (snapshot JSON)
- [x] Stimulus `cart_badge_controller.js` — badge compteur header, refresh via event `cart:updated`
- [x] Stimulus `cart_add_controller.js` — ajout AJAX avec feedback visuel ("Ajouté !"), fallback form submit
- [x] `CartController.php` — 5 routes : `/panier` (index), `/panier/ajouter` (POST + AJAX), `/panier/modifier`, `/panier/supprimer`, `/panier/count` (JSON)
- [x] `_partials/_cart_badge.html.twig` — partial réutilisable, conditionné par module `ecommerce`
- [x] Badge panier intégré dans les 6 headers de thèmes (desktop + mobile top bar + mobile offcanvas)
- [x] `templates/cart/index.html.twig` — tableau desktop + cards mobile, état vide, totaux, boutons "Continuer" + "Commander"
- [x] `cart.scss` — styles avec CSS custom properties (adapté à tous les thèmes)

### 11.2 Checkout & Paiement ✅

- [x] `CheckoutType.php` — formulaire : prénom, nom, email, téléphone, message, choix paiement (Stripe masqué si non configuré)
- [x] `CheckoutController.php` :
  - `GET/POST /commander` — récap panier + formulaire + création commande
  - Stripe : crée Checkout Session, redirect vers Stripe, fallback manuel si erreur
  - Manuel : commande `pending`, emails, page confirmation
  - `GET /commande/confirmation/{reference}` — page merci
  - `GET /commande/annulation/{reference}` — page annulation Stripe
  - Guard `hasModule('ecommerce')`
- [x] `StripeService.php` — crée Checkout Session, vérifie webhook, résout clés depuis Site (admin) > `.env` (fallback)
- [x] Webhook `POST /webhook/stripe` — écoute `checkout.session.completed`, valide paiement, envoie emails
- [x] Config Stripe dans admin : 3 champs sur `Site` (stripePublicKey, stripeSecretKey, stripeWebhookSecret) — panel "Paiement Stripe" visible `ROLE_FREELANCE+`
- [x] Config `.env` : `STRIPE_SECRET_KEY`, `STRIPE_PUBLIC_KEY`, `STRIPE_WEBHOOK_SECRET` (fallback)
- [x] `stripe/stripe-php` v19 installé

### 11.3 Entité Order ✅

- [x] `Order.php` — reference auto BW-YYYYMMDD-XXXXX, customerFirst/LastName, email, phone, message, items JSON, totalHT/VAT/TTC, paymentMethod (enum), stripeSessionId, status (enum), createdAt, paidAt
- [x] `OrderStatusEnum.php` — pending, paid, cancelled, refunded (avec label/cssClass)
- [x] `PaymentMethodEnum.php` — stripe, manual (avec label/icon)
- [x] `OrderRepository.php` — findRecent, countByStatus, revenueThisMonth, countPaidThisMonth, revenueByMonth
- [x] Migrations exécutées

### 11.4 Admin commandes ✅

- [x] `OrderCrudController.php` (`ROLE_ADMIN`) — liste (reference, client, statut badge couleur, total €, date) + détail complet + filtres (statut, paiement, date)
- [x] Pas de création/suppression — lecture + modification statut uniquement
- [x] Menu "Commandes" conditionné par module `ecommerce`

### 11.5 Notifications email ✅

- [x] Email confirmation client — référence, récap items, totaux, instructions paiement si manuel
- [x] Email notification admin — nouvelle commande, infos client, montant, méthode
- [x] Templates : `emails/order_confirmation.html.twig`, `emails/order_admin_notification.html.twig`
- [x] Envoi intégré dans CheckoutController (manuel) et webhook (Stripe)

### 11.6 Dashboard widget

- [ ] Widget EasyAdmin sur le dashboard (conditionné par module `ecommerce`) : 5 dernières ventes, CA du mois, nombre commandes payées
- [ ] `OrderRepository` : méthodes prêtes (findRecent, revenueThisMonth, countPaidThisMonth) — à câbler dans DashboardController

### 11.7 Front templates ✅

- [x] `templates/cart/index.html.twig` — tableau desktop + cards mobile, état vide, totaux
- [x] `templates/checkout/index.html.twig` — formulaire client + récap + choix paiement (radio)
- [x] `templates/checkout/confirmation.html.twig` — page merci avec récap items
- [x] `templates/checkout/cancel.html.twig` — page annulation Stripe
- [x] `templates/emails/order_confirmation.html.twig` + `order_admin_notification.html.twig`
- [x] `cart.scss` — styles CSS custom properties (adapté aux 6 thèmes)
- [x] Bouton "Ajouter au panier" sur `product/show.html.twig` (si ecommerce + prix + disponible)
- [x] Vérifié visuellement sur les 6 thèmes (default, corporate, artisan, vitrine, starter, moderne)

### 11.8 Liaison Event ↔ Product ✅

- [x] `linkedProduct` (FK Product, nullable, SET NULL) sur `Event`
- [x] Migration exécutée
- [x] Admin `EventCrudController` : AssociationField `linkedProduct` dans panel Paramètres
- [x] Front `event/show.html.twig` : bloc "Inscription / Tarif" dans la sidebar — prix + bouton "Ajouter au panier" si ecommerce + prix + disponible, sinon "Nous contacter"

**Fichiers créés (~18) :** `CartService.php`, `StripeService.php`, `CartController.php`, `CheckoutController.php`, `CheckoutType.php`, `OrderCrudController.php`, `cart_badge_controller.js`, `cart_add_controller.js`, `_cart_badge.html.twig`, `cart/index.html.twig`, `checkout/index.html.twig`, `checkout/confirmation.html.twig`, `checkout/cancel.html.twig`, `emails/order_confirmation.html.twig`, `emails/order_admin_notification.html.twig`, `cart.scss`
**Fichiers modifiés (~15) :** `Event.php`, `Site.php` (3 champs Stripe), `EventCrudController.php`, `SiteCrudController.php` (panel Paiement), `DashboardController.php` (menu Commandes), `product/show.html.twig` (bouton CTA panier), `event/show.html.twig` (bloc produit lié), 6 `_header.html.twig` (badge panier), `main.scss`, `services.yaml`, `.env`
**Dépendances :** `stripe/stripe-php` v19
**Migrations :** 2 (Event.linkedProduct + Site.stripe*)

---

## Phase 12 — Navigation, Pages Légales & Cookie Consent ✅

> **Approche** : theme.yaml déclare les zones de menu + items système → matérialisés en BDD par les commandes init/sync → admin peut éditer/réordonner/masquer mais pas supprimer les items système.

### 12.1 Entités & Migration ✅

#### Menu entity — 5 nouveaux champs

| Champ | Type | Default | Notes |
|-------|------|---------|-------|
| `location` | string(20) | `'header'` | Zone : `header`, `footer_nav`, `footer_legal` (indexé) |
| `is_system` | bool | false | Items créés par init/sync, non-supprimables |
| `system_key` | string(50) | null | ID unique par zone (`home`, `blog`, `contact`, `mentions-legales`...) |
| `route` | string(100) | null | Route Symfony (prioritaire sur target/article/page) |
| `route_params` | JSON | null | Params de route (ex: `{"type": "mentions-legales"}`) |

- [x] Modifier `src/Entity/Menu.php` avec les 5 champs
- [x] Index UNIQUE `(location, system_key)` — MariaDB autorise NULL multiples
- [x] Index sur `location`

#### Page entity — 2 nouveaux champs

| Champ | Type | Default | Notes |
|-------|------|---------|-------|
| `is_system` | bool | false | Pages légales non-supprimables |
| `system_key` | string(50) | null | Unique : `mentions-legales`, `politique-confidentialite`, `cgv`, `cgu` |

- [x] Modifier `src/Entity/Page.php`

#### Nouveaux Enums

- [x] `src/Enum/SystemPageEnum.php` — `MENTIONS_LEGALES`, `POLITIQUE_CONFIDENTIALITE`, `CGV`, `CGU`
  - `requiredModule()` → null (toujours) / `ecommerce` / `services`
  - `title()`, `slug()`, `defaultContent()` (TipTap avec sections `[À COMPLÉTER]`)
  - `alwaysRequired()` → mentions + confidentialité
- [x] `src/Enum/MenuLocationEnum.php` — `HEADER`, `FOOTER_NAV`, `FOOTER_LEGAL`

#### Migration
- [x] ALTER menu : +5 colonnes, index location, unique (location, system_key)
- [x] ALTER page : +2 colonnes, unique system_key
- Données existantes préservées : tous les Menu → `location='header'`, `is_system=false`

### 12.2 theme.yaml : zones de menu ✅

Le `theme.yaml` déclare les zones et items système. Les autres thèmes héritent de `default` si pas de section `menus`.

```yaml
# templates/themes/default/theme.yaml
menus:
  header:
    label: "Navigation principale"
    items:
      - { system_key: "home", name: "Accueil", route: "app_home" }
      - { system_key: "blog", name: "Blog", route: "app_article_show_all", module: "blog" }
      - { system_key: "services", name: "Services", route: "app_service_index", module: "services" }
      - { system_key: "catalogue", name: "Catalogue", route: "app_product_index", module: "catalogue" }
      - { system_key: "events", name: "Événements", route: "app_event_index", module: "events" }
      - { system_key: "annuaire", name: "Annuaire", route: "app_directory", module: "directory" }
      - { system_key: "contact", name: "Contact", route: "app_contact" }
  footer_nav:
    label: "Navigation footer"
    items:
      - { system_key: "home", name: "Accueil", route: "app_home" }
      - { system_key: "blog", name: "Blog", route: "app_article_show_all", module: "blog" }
      - { system_key: "contact", name: "Contact", route: "app_contact" }
  footer_legal:
    label: "Liens légaux"
    items:
      - { system_key: "mentions-legales", name: "Mentions légales", route: "app_legal_page", route_params: { type: "mentions-legales" } }
      - { system_key: "politique-confidentialite", name: "Politique de confidentialité", route: "app_legal_page", route_params: { type: "politique-confidentialite" } }
      - { system_key: "cgv", name: "CGV", route: "app_legal_page", route_params: { type: "cgv" }, module: "ecommerce" }
      - { system_key: "cgu", name: "CGU", route: "app_legal_page", route_params: { type: "cgu" }, module: "services" }
```

- [x] Ajouter section `menus` dans `templates/themes/default/theme.yaml`
- [x] `ThemeService` : `getMenuZones()`, `getMenuItemsForZone()` avec fallback default

### 12.3 Services ✅

#### MenuSyncService (nouveau)
**Fichier** : `src/Service/MenuSyncService.php`

- [x] `syncAllZones(Site $site)` — lit theme.yaml, sync chaque zone
- [x] `syncZone()` — upsert par system_key, masque si module inactif, préserve customisations admin (name, order)
- [x] Gestion des orphelins après changement de thème

#### LegalPageContentService (nouveau)
**Fichier** : `src/Service/LegalPageContentService.php`

- [x] `createIfNotExists(SystemPageEnum $type): Page` — crée page système avec contenu HTML riche pré-rempli
- [x] Contenu riche avec tableaux, listes structurées et placeholders `{{À_COMPLÉTER}}` :
  - **mentions-legales** : Éditeur (tableau), Hébergeur (tableau), Propriété intellectuelle, Protection des données, Cookies (tableau), Limitation responsabilité, Droit applicable, Contact
  - **politique-confidentialite** : Responsable traitement, Données collectées (3 sous-sections avec tableaux), Finalités, Base légale (tableau), Ce qu'on ne fait pas, Cookies (2 tableaux), Sous-traitants (tableau), Droits RGPD (tableau), Sécurité, Contact
  - **cgv** : Objet, Vendeur, Prix, Commande (liste numérotée), Paiement, Livraison (tableau), Rétractation, Garanties, Responsabilité, Réclamations, Contact
  - **cgu** : Objet, Éditeur, Accès, Inscription, Services, Propriété intellectuelle, Comportement utilisateur, Responsabilité, Liens hypertextes, Données perso, Modification CGU, Droit applicable, Contact
- [x] SEO description auto-remplie, `noIndex: true` par défaut

#### MenuService — mise à jour
- [x] `findByLocation(string $location): array` — méthode principale, filtre zone + visibilité
- [x] `findMenuTwig()` → délègue à `findByLocation('header')` (rétrocompat)

#### MenuRepository
- [x] `findByLocation(string $location)` — eager-load, filtre visible, tri menu_order
- [x] `findSystemByLocationAndKey(string $location, string $key): ?Menu`

#### AppExtension — update menuLink
- [x] Si `$menu->getRoute()` → `$router->generate(route, params)` (prioritaire sur target/article/page)

### 12.4 Pages légales ✅

#### LegalController (nouveau)
**Fichier** : `src/Controller/LegalController.php`

```php
#[Route('/{type}', name: 'app_legal_page',
    requirements: ['type' => 'mentions-legales|politique-de-confidentialite|conditions-generales-de-vente|conditions-generales-utilisation'],
    priority: -10)]
```

- [x] Charge Page par `system_key`, 404 si pas trouvée
- [x] Réutilise `page/show.html.twig` (template full-width)
- [x] SEO via `SeoService::resolve($page)`

#### SitemapController
- [x] Ajouter pages légales publiées au sitemap (priority 0.3, changefreq yearly)

#### Commande utilitaire
- [x] `app:legal-pages:update` — met à jour le contenu des pages légales existantes avec le dernier template

### 12.5 Templates thèmes (6 headers + 6 footers) ✅

#### base.html.twig
```twig
{% set header_menus = menu_service.findByLocation('header') %}
{% set footer_nav_menus = menu_service.findByLocation('footer_nav') %}
{% set footer_legal_menus = menu_service.findByLocation('footer_legal') %}
```
- [x] Supprimer script GA inline (géré par cookie consent)
- [x] Ajouter `{% include '_partials/_cookie_consent.html.twig' %}`

#### 6 Headers — même pattern
- [x] Remplacer liens hardcodés (Accueil, Blog, Contact) par boucle `header_menus`
- [x] Support dropdown pour sous-menus
- [x] Conserver éléments fonctionnels (search, cart, login)

#### 6 Footers — même pattern
- [x] Colonne Navigation → boucle `footer_nav_menus`
- [x] Colonne Légal → boucle `footer_legal_menus`
- [x] Conserver colonne Contact + liens sociaux

### 12.6 Admin CRUD ✅

#### MenuCrudController
- [x] `location` (ChoiceField), `is_system` (BooleanField readonly), badge visuel
- [x] Filtre par `location` sur l'index
- [x] Bloquer suppression si `is_system = true`

#### PageCrudController
- [x] `is_system` (BooleanField readonly), slug readonly si système
- [x] Bloquer suppression pages système
- [x] TipTap reste éditable (client remplit ses infos légales)

### 12.7 Commandes ✅

#### app:init-site — enrichi
- [x] Après création Site : crée pages légales obligatoires + sync menus système
- [x] Résumé console

#### app:module:enable {module} (nouveau)
- [x] Active module dans `Site.enabledModules`
- [x] Crée pages légales du module (ex: CGV pour ecommerce)
- [x] Sync menus (rend visible les items du module)

#### app:module:disable {module} (nouveau)
- [x] Retire de `Site.enabledModules`
- [x] Masque items menu (`is_visible = false`)
- [x] Dépublie pages légales du module (préserve contenu)

#### app:menu:sync (nouveau)
- [x] Re-sync tous les items système depuis theme.yaml (utile après changement de thème)

#### app:legal-pages:update (nouveau)
- [x] Met à jour le contenu HTML des pages légales existantes avec le dernier template

### 12.8 Bandeau Cookies (RGPD) ✅

- [x] Stimulus `cookie_consent_controller.js` :
  - Check localStorage, affiche banner si pas de choix
  - Accepter → stocke consent, charge GA dynamiquement
  - Refuser → stocke refus, pas de GA
- [x] Template `_partials/_cookie_consent.html.twig` — fixed bottom, 2 boutons, lien politique confidentialité
- [x] Affiché seulement si `site.googleAnalyticsId` configuré
- [x] CSS dans `global.scss`

### 12.9 Refonte CRUD Menu — Gestionnaire de Navigation ✅

> Interface d'administration des menus refaite façon WordPress : 2 colonnes, sources à gauche, zones à droite.

#### Layout 2 colonnes
- [x] **Colonne gauche (30%) — Sources disponibles** :
  - Accordéon "Pages système" : Accueil, Contact, pages légales (filtrées par modules actifs)
  - Accordéon "Pages" : pages publiées non-système
  - Accordéon "Catégories" : catégories d'articles
  - Accordéon "Modules" : routes des modules actifs (Blog, Catalogue, Services, Événements, Annuaire)
  - Bloc "Lien personnalisé" : champs Titre + URL + bouton Ajouter
  - Bloc "Parent / Sous-menu" : crée un élément vide pour regrouper des sous-menus

- [x] **Colonne droite (70%) — Zones de menu (3 onglets)** :
  - Navigation principale (header)
  - Footer navigation
  - Footer légal
  - Chaque onglet : liste drag-and-drop SortableJS avec 2 niveaux max

#### Fonctionnalités
- [x] **Ajout depuis sources** : checkboxes + bouton "Ajouter la sélection" → AJAX POST crée le Menu entity + injection DOM
- [x] **Drag-and-drop** : SortableJS, réordonner + imbriquer (2 niveaux max), sauvegarde auto AJAX
- [x] **Édition inline** : double-clic sur un nom → input text, sauvegarde AJAX au blur/Enter
- [x] **Toggle visibilité** : œil/œil barré, sauvegarde AJAX
- [x] **Suppression** : poubelle (refuse si is_system), détache les enfants avant suppression
- [x] **Items système** : badge "Système" bleu, non-supprimables, éditables (nom, ordre, visibilité)
- [x] **Badges colorés** : Système (bleu), Page (vert), Catégorie (jaune), Module (bleu), Lien (gris) — texte blanc
- [x] **Items masqués** : opacité réduite (0.45) avec icône œil barré
- [x] **Enregistrement 100% auto** : chaque action = appel AJAX instantané, pas de bouton Enregistrer
- [x] **Responsive** : stack vertical sur mobile (<992px)

#### API endpoints (5)
| Route | Méthode | Action |
|-------|---------|--------|
| `/admin/api/menu/reorder` | POST | Réordonner (existant) |
| `/admin/api/menu/toggle-visibility/{id}` | POST | Toggle visible (existant) |
| `/admin/api/menu/add` | POST | Créer un item (nouveau) |
| `/admin/api/menu/delete/{id}` | POST | Supprimer non-système (nouveau) |
| `/admin/api/menu/rename/{id}` | POST | Renommer inline (nouveau) |

#### Intégration admin sidebar
- [x] "Navigation" déplacé de "Administration" vers "Apparence" (accessible `ROLE_ADMIN`)
- [x] Section "Apparence" visible dès `ROLE_ADMIN` (Navigation), le reste `ROLE_FREELANCE`

#### Backend
- [x] `MenuRepository::findByLocationAllItems()` — tous les items (visibles + cachés) pour une zone
- [x] `MenuRepository::getNextOrder()` — prochain menu_order pour une zone
- [x] `PageRepository::findCustomPages()` — pages publiées non-système
- [x] `MenuApiController` : 3 nouvelles routes (add, delete, rename) + CSRF validation
- [x] `DashboardController::menuManager()` : enrichi avec sources (pages système, custom, catégories, modules)

**Fichiers réécrits/modifiés (7) :** `templates/admin/menu/sortable.html.twig` (réécriture complète), `assets/admin/menu-sortable.js` (~280 lignes, réécriture complète), `assets/admin/menu-sortable.scss` (refonte styles), `MenuApiController.php` (+3 routes), `DashboardController.php` (menuManager enrichi + sidebar réorganisée), `MenuRepository.php` (+2 méthodes), `PageRepository.php` (+1 méthode)

### Fichiers créés (~11)
`SystemPageEnum.php`, `MenuLocationEnum.php`, `MenuSyncService.php`, `LegalPageContentService.php`, `LegalController.php`, `LegalPagesUpdateCommand.php`, `ModuleEnableCommand.php`, `ModuleDisableCommand.php`, `MenuSyncCommand.php`, `cookie_consent_controller.js`, `_cookie_consent.html.twig`

### Fichiers modifiés (~30)
`Menu.php`, `Page.php`, `MenuService.php`, `ThemeService.php`, `MenuRepository.php`, `PageRepository.php`, `AppExtension.php`, `InitSiteCommand.php`, `MenuCrudController.php`, `PageCrudController.php`, `MenuApiController.php`, `DashboardController.php`, `SitemapController.php`, `base.html.twig`, `templates/admin/menu/sortable.html.twig`, `assets/admin/menu-sortable.js`, `assets/admin/menu-sortable.scss`, 6× `_header.html.twig`, 6× `_footer.html.twig`, `templates/themes/default/theme.yaml`, `global.scss`, `SETUP.md`

### Migration
Oui — Menu (+5 colonnes, indexes) + Page (+2 colonnes, unique)

---

## ~~Phase 13 — Sections Configurables Home & Sidebar~~ ❌ ANNULÉE

> **Décision** : Sur-engineering. Le modèle commercial est du service (installation + personnalisation par David/freelance via Claude Code), pas du SaaS. L'admin client se concentre sur son contenu, pas sur la structure de sa homepage. Les sections sont déjà conditionnelles via `{% if modules %}` dans les templates — suffisant.

---

## Dette technique & Items ponctuels restants

### Items ponctuels à faire

| Source | Item | Priorité |
|--------|------|----------|
| Phase 8 | Checkbox `subscribeEvents` dans formulaire profil utilisateur | Basse |
| Phase 8 | Intégrer événements dans les 5 autres thèmes homepage | Basse |
| Phase 11 | Widget dashboard e-commerce (5 dernières ventes, CA mois, commandes payées) | Moyenne |

### Dette technique

| Item | Priorité | Notes |
|------|----------|-------|
| `docker-compose.prod.yml` | Haute (déploiement) | opcache max, restart always, pas de Xdebug |
| Sécurité prod (SSL, Fail2ban, backups, CSP) | Haute (déploiement) | Config serveur |
| Typos `adress_1/2` → `address_1/2` | Basse | Renommage champs Site + migration |
| Vérification email installée mais non activée | Basse | VerifyEmailBundle câblé mais pas en production |
| Abonnements `news`/`articles` sur User : stockés mais jamais utilisés | Basse | Soit câbler soit supprimer |

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
