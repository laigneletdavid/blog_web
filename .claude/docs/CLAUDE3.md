# Blog & Web — Phase 10 : Modules FAQ + Portfolio

## Vue d'ensemble

Deux nouveaux modules activables par site, suivant les conventions etablies (ModuleEnum, guard routes, DashboardController conditionnel, ContentSanitizeListener, Sitemap).

---

## Phase 10.1 — Module FAQ ✓ TERMINE

> Implemente le 2026-03-26

### Fichiers crees

| Fichier | Role |
|---------|------|
| `src/Entity/Faq.php` | Question + reponse TipTap (blocks/content) + categorie + icon + position |
| `src/Entity/FaqCategory.php` | Categorie avec nom, slug, position, isActive |
| `src/Repository/FaqRepository.php` | `findAllActive`, `findAllActiveGroupedByCategory`, `findActiveByCategory`, `findOneActiveBySlug` |
| `src/Repository/FaqCategoryRepository.php` | `findAllActive` |
| `src/Controller/Admin/FaqCrudController.php` | CRUD admin — Panel Contenu (question, blocksJson TipTap, icon) + Panel Parametres (slug auto, category, position, isActive) |
| `src/Controller/Admin/FaqCategoryCrudController.php` | CRUD categories — name, slug auto, position, isActive |
| `src/Controller/FaqController.php` | Front `GET /faq` — guard module, groupement par categorie, SeoService |
| `templates/faq/index.html.twig` | Accordeon Bootstrap 5 + Schema.org FAQPage JSON-LD + breadcrumb |
| `templates/_partials/_faq_accordion.html.twig` | Partial homepage (6 FAQ max + lien "Voir toutes les questions") |
| `assets/css/base/faq.scss` | Styles globaux (custom properties, responsive) |
| `migrations/Version20260326064334.php` | Tables `faq` + `faq_category` |

### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `src/Enum/ModuleEnum.php` | Ajout `FAQ = 'faq'` + label |
| `src/Controller/Admin/DashboardController.php` | Menu FAQ conditionnel (subMenu Questions + Categories), `$hasModules`, moduleMap route `app_faq_index`, passage `site` au guide |
| `src/EventListener/ContentSanitizeListener.php` | Ajout `Faq` dans les entites traitees |
| `src/Controller/SitemapController.php` | Ajout `/faq` conditionnel (priority 0.5, monthly) |
| `templates/sitemap/index.xml.twig` | Bloc `{% if hasFaq %}` |
| `assets/css/main.scss` | Import `faq.scss` |
| `templates/admin/guide/index.html.twig` | Section FAQ dans le guide (conditionnee par module actif) |

### Overrides CSS par theme

| Theme | Override |
|-------|---------|
| `default` | Squelette commente (personnalisable) |
| `corporate` | Titre categorie serif uppercase, accordion-button 0.375rem radius |
| `artisan` | Titre categorie serif (Playfair Display), radius 1rem, icones accent vert |
| `moderne` | Dark mode : surface/border/text adaptes, liens accent cyan, hover violet |
| `starter` | Minimaliste : radius 0.375rem, border fine, font-size reduit |
| `vitrine` | Titre categorie indigo, radius 0.625rem |

### Decisions d'implementation

- **Pas de page detail** `/faq/{slug}` — tout sur `/faq` en accordeon. Le slug sert d'ancre `#slug`.
- **Champ `content`** (TEXT) = cache HTML compile depuis `blocks` (JSON TipTap) via `ContentSanitizeListener`.
- **Alias `getTitle()`** dans Faq.php → retourne `question` (compatibilite ContentSanitizeListener).
- **Partial homepage** `_faq_accordion.html.twig` pret mais non integre dans les themes (activation en surcouche).

---

## Phase 10.2 — Module Portfolio / Realisations

> Prerequis : Phase 6.1 (enabledModules)
> Estimation : ~1 jour
> Pattern de reference : module Services (listing + page detail + blocks TipTap)

### 10.2.1 Entite PortfolioCategory + Migration

- [ ] `src/Entity/PortfolioCategory.php` :
  - `id` (int, auto)
  - `name` (string 255, NotBlank)
  - `slug` (string 255, unique)
  - `icon` (string 100, nullable) — icone Bootstrap Icons
  - `position` (int, default 0)
  - `isActive` (bool, default true)
  - `__toString()` → name
  - Relation `OneToMany` vers `PortfolioItem`

### 10.2.2 Entite PortfolioItem + Migration

- [ ] `src/Entity/PortfolioItem.php` :
  - `id` (int, auto)
  - `title` (string 255, NotBlank)
  - `slug` (string 255, unique)
  - `shortDescription` (TEXT, nullable) — resume affiche dans la grille
  - `blocks` (JSON, nullable) — contenu TipTap (page detail)
  - `content` (TEXT) — cache HTML compile
  - `client` (string 255, nullable) — nom du client
  - `projectDate` (date, nullable) — date de realisation
  - `projectUrl` (string 255, nullable, Assert\Url) — lien vers le projet en ligne
  - `category` (ManyToOne → PortfolioCategory, nullable, onDelete SET NULL)
  - `image` (ManyToOne → Media, nullable) — image principale / couverture
  - `gallery` (JSON, nullable) — tableau d'IDs Media pour galerie additionnelle
  - `tags` (string 255, nullable) — tags libres (technologies, competences)
  - `position` (int, default 0) — tri manuel
  - `isActive` (bool, default true)
  - `isFeatured` (bool, default false) — mis en avant sur homepage
  - `use SeoTrait;` — champs SEO complets
  - Virtual `getBlocksJson()` / `setBlocksJson()`
  - `__toString()` → title
  - Index sur `is_active`, `is_featured`
- [ ] Migration Doctrine

### 10.2.3 Repository

- [ ] `src/Repository/PortfolioCategoryRepository.php` :
  - `findAllActive(): array`
- [ ] `src/Repository/PortfolioItemRepository.php` :
  - `findAllActive(): array` — orderBy position ASC, isActive=true
  - `findActiveByCategory(PortfolioCategory $category): array`
  - `findFeatured(int $limit = 6): array` — isFeatured=true, isActive=true
  - `findOneActiveBySlug(string $slug): ?PortfolioItem`
  - `findAllActiveForSitemap(): array` — filtre noIndex=false

### 10.2.4 ModuleEnum

- [ ] Ajouter `PORTFOLIO = 'portfolio'` dans `ModuleEnum.php`
- [ ] Label : `'Portfolio / Realisations'`

### 10.2.5 CRUD Admin

- [ ] `src/Controller/Admin/PortfolioCategoryCrudController.php` (`#[IsGranted('ROLE_ADMIN')]`) :
  - Panel unique : name, slug (auto), icon, position, isActive
- [ ] `src/Controller/Admin/PortfolioItemCrudController.php` (`#[IsGranted('ROLE_ADMIN')]`) :
  - Panel "Contenu" : title, shortDescription, blocksJson (TipTap), image (AssociationField Media)
  - Panel "Projet" : client, projectDate, projectUrl, tags
  - Panel "SEO" : 5 champs SeoTrait (seoTitle, seoDescription, seoKeywords, noIndex, canonicalUrl)
  - Panel "Parametres" : slug (auto target title), category (AssociationField), position, isActive, isFeatured
  - Index : title, category, client, isActive (toggle), isFeatured, position
  - Tri default : position ASC
  - Filters : category, isActive, isFeatured

### 10.2.6 DashboardController

- [ ] Section Modules : ajouter menu conditionnel Portfolio
  ```php
  if ($this->siteContext->hasModule('portfolio')) {
      yield MenuItem::subMenu('Portfolio', 'fas fa-images')->setSubItems([
          MenuItem::linkToCrud('Realisations', 'fas fa-briefcase', PortfolioItem::class),
          MenuItem::linkToCrud('Categories', 'fas fa-folder-open', PortfolioCategory::class),
      ]);
  }
  ```
- [ ] Ajouter `'portfolio'` dans la condition `$hasModules`

### 10.2.7 Front Controller

- [ ] `src/Controller/PortfolioController.php` :
  - `GET /realisations` — index : grille filtrable par categorie (pills), pagination
  - `GET /realisation/{slug}` — show : page detail avec galerie, infos projet, contenu TipTap
  - Guard `hasModule('portfolio')` → 404 si desactive
  - SEO via `SeoService` (resolve pour show, resolveForPage pour index)
  - Filtre categorie via query param `?categorie=slug` (meme pattern que blog)

### 10.2.8 Templates

- [ ] `templates/portfolio/index.html.twig` :
  - Titre "Nos realisations"
  - Filtres par categorie : pills horizontales (meme pattern que blog)
  - Grille responsive : 3 colonnes desktop, 2 tablette, 1 mobile
  - Card portfolio : image ratio 4:3, overlay hover avec titre + categorie, badge client
  - Pagination
  - Etat vide
- [ ] `templates/portfolio/show.html.twig` :
  - Layout col-lg-8 (contenu) + col-lg-4 (sidebar)
  - Image hero principale
  - Meta : date, client, categorie, tags
  - Contenu TipTap
  - Galerie images (grille cliquable, lightbox Stimulus optionnel)
  - Lien projet externe (bouton CTA si projectUrl)
  - Sidebar : infos projet (card recapitulative), autres realisations (meme categorie)
  - Bouton retour
- [ ] `templates/_partials/_portfolio_grid.html.twig` — partial reutilisable (pour homepage themes)
- [ ] `templates/_partials/_portfolio_card.html.twig` — card individuelle

### 10.2.9 Integrations

- [ ] `ContentSanitizeListener` : ajouter `PortfolioItem` (compile blocks → content HTML)
- [ ] `SitemapController` : ajouter realisations (priority 0.6, monthly, conditionne par module)
- [ ] `HomeController` : passer `featuredPortfolio` si module portfolio actif (via `findFeatured()`)
- [ ] `WidgetService` : `findFeaturedPortfolio()` (optionnel, pour sidebar)

### 10.2.10 CSS

- [ ] `assets/css/base/portfolio.scss` :
  - `.portfolio-section` — conteneur page
  - `.portfolio-filters` — pills categories (reutiliser pattern blog-filters)
  - `.portfolio-grid` — grille responsive CSS Grid
  - `.portfolio-card` — card avec image, overlay hover (translateY + opacity), badge categorie
  - `.portfolio-detail` — page detail (hero, meta, contenu, galerie, sidebar)
  - `.portfolio-gallery` — grille images cliquable
  - `.portfolio-info-card` — widget sidebar infos projet
  - Responsive tablette + mobile
  - 100% CSS custom properties (compatible 6 themes)
- [ ] Import dans `main.scss`

**Fichiers a creer :** `PortfolioItem.php`, `PortfolioCategory.php`, `PortfolioItemRepository.php`, `PortfolioCategoryRepository.php`, `PortfolioItemCrudController.php`, `PortfolioCategoryCrudController.php`, `PortfolioController.php`, `portfolio/index.html.twig`, `portfolio/show.html.twig`, `_portfolio_grid.html.twig`, `_portfolio_card.html.twig`, `portfolio.scss`
**Fichiers a modifier :** `ModuleEnum.php`, `DashboardController.php`, `ContentSanitizeListener.php`, `SitemapController.php`, `sitemap/index.xml.twig`, `HomeController.php`, `main.scss`
**Migrations :** 1 (tables `portfolio_item` + `portfolio_category`)

---

## Offres commerciales (mise a jour)

### Sous-modules (ajoutables a tout bundle)

| Sous-module | Ce qu'il apporte | Cible |
|-------------|-----------------|-------|
| **Evenements** (`events`) | Calendrier, alertes abonnes | Assos, ecoles, collectivites |
| **Pages privees** (`private_pages`) | Contenu restreint aux membres | Assos d'entreprises, clubs |
| **Annuaire** (`directory`) | Liste membres/entreprises | Assos d'entreprises, reseaux |
| **FAQ** (`faq`) | Foire aux questions, SEO FAQPage | Tous profils (SEO, support) |
| **Portfolio** (`portfolio`) | Realisations, projets clients | Freelances, agences, artisans |

### Modules totaux apres Phase 10 : 10

```
VITRINE, SERVICES, BLOG, CATALOGUE, ECOMMERCE, EVENTS, PRIVATE_PAGES, DIRECTORY, FAQ, PORTFOLIO
```

---

## Ordre d'implementation recommande

1. **FAQ d'abord** — plus simple, moins de fichiers, pas de SeoTrait, pas de galerie
2. **Portfolio ensuite** — plus complexe, galerie, SeoTrait, filtres categories, homepage integration

---

## Decisions de design

- **FAQ** : pas de page detail individuelle `/faq/{slug}` — tout est sur `/faq` en accordeon. Le slug sert d'ancre (`#slug`) pour les liens directs. Plus simple, meilleur UX, meilleur SEO (tout le JSON-LD sur une seule page).
- **Portfolio gallery** : champ JSON (tableau d'IDs Media) plutot qu'une table de jointure — plus simple, suffisant pour 5-15 images par projet. Les images sont chargees via le MediaRepository.
- **Portfolio vs Catalogue** : modules separes, pas de reutilisation. Un client peut avoir les deux sans conflit.
- **Nommage routes** : `/realisations` et `/realisation/{slug}` (francais, coherent avec `/evenements`, `/services`).
