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

## Phase 10.2 — Module Portfolio / Realisations ✓ TERMINE

> Implemente le 2026-03-26

### Fichiers crees

| Fichier | Role |
|---------|------|
| `src/Entity/PortfolioItem.php` | Realisation avec titre, description, blocks TipTap, client, date, URL projet, image, tags (ManyToMany Tag), SeoTrait |
| `src/Entity/PortfolioCategory.php` | Categorie avec nom, slug, icon, position, isActive |
| `src/Repository/PortfolioItemRepository.php` | `findAllActive`, `findFeatured`, `findActiveByCategory`, `findOneActiveBySlug`, `findAllActiveForSitemap` |
| `src/Repository/PortfolioCategoryRepository.php` | `findAllActive` |
| `src/Controller/Admin/PortfolioItemCrudController.php` | CRUD admin — Panels Contenu/Projet/Referencement/Parametres avec helps detailles |
| `src/Controller/Admin/PortfolioCategoryCrudController.php` | CRUD categories |
| `src/Controller/PortfolioController.php` | Front `GET /realisations` (index filtrable) + `GET /realisation/{slug}` (detail) |
| `templates/portfolio/index.html.twig` | Grille filtrable par categorie (pills) |
| `templates/portfolio/show.html.twig` | Page detail avec meta, contenu TipTap, tags, CTA projet, breadcrumb |
| `templates/_partials/_portfolio_card.html.twig` | Card portfolio reutilisable (image, badge categorie, client, excerpt) |
| `templates/_partials/_portfolio_grid.html.twig` | Grille homepage (6 items max + lien "Voir toutes") |
| `assets/css/base/portfolio.scss` | Styles globaux (grille, card, detail, filtres, responsive) |
| `migrations/Version20260326070851.php` | Tables `portfolio_item` + `portfolio_category` + jointure `portfolio_item_tag` |

### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `src/Enum/ModuleEnum.php` | Ajout `PORTFOLIO = 'portfolio'` + label |
| `src/Controller/Admin/DashboardController.php` | Menu Portfolio conditionnel, `$hasModules`, moduleMap route `app_portfolio_index` |
| `src/EventListener/ContentSanitizeListener.php` | Ajout `PortfolioItem` dans les entites traitees |
| `src/Controller/SitemapController.php` | Ajout realisations dans le sitemap (priority 0.6, monthly) |
| `templates/sitemap/index.xml.twig` | Boucle `portfolioItems` |
| `src/Controller/HomeController.php` | Passage `faqs` + `featuredPortfolio` aux templates home |
| `assets/css/main.scss` | Import `portfolio.scss` |
| 6x `templates/themes/*/home.html.twig` | Sections FAQ + Portfolio conditionnelles |
| `SETUP.md` | Ajout modules faq + portfolio dans la doc |
| `README.md` | Ajout FAQ + Portfolio dans la liste des modules |

### Overrides CSS par theme

| Theme | Override |
|-------|---------|
| `default` | Squelette commente (personnalisable) |
| `corporate` | Cards avec radius reduit, hover subtle |
| `artisan` | Radius genereux 1rem, hover chaleureux |
| `moderne` | Dark mode : surface/border adaptes, gradient hover |
| `starter` | Minimaliste : radius 0.375rem, pas d'overlay |
| `vitrine` | Hover indigo, radius intermediaire |

### Decisions d'implementation

- **Tags relies a la table Tag** existante (ManyToMany) — partages avec blog et catalogue.
- **Chemin medias** : `documents/medias/` (corrige depuis `uploads/medias/` sur services aussi).
- **Filtres categories** : via query param `?categorie=slug` (meme pattern que blog).
- **Routes francaises** : `/realisations` et `/realisation/{slug}`.
- **SeoTrait** integre pour SEO complet sur chaque realisation.

### 10.2.1 Entite PortfolioCategory + Migration (ancien plan)

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

## Phase 10.3 — Ameliorations editeur TipTap ✓ TERMINE

> Implemente le 2026-03-27

### Extensions ajoutees

| Extension | Package npm | Usage |
|-----------|-------------|-------|
| Underline | `@tiptap/extension-underline` | Soulignement texte |
| Highlight | `@tiptap/extension-highlight` | Surlignage colore |
| TextAlign | `@tiptap/extension-text-align` | Alignement gauche/centre/droite |
| CharacterCount | `@tiptap/extension-character-count` | Compteur caracteres/mots en bas |
| Suggestion | `@tiptap/suggestion` | Installe (slash commands custom) |

### Custom nodes crees

| Fichier | Role |
|---------|------|
| `assets/admin/extensions/callout.js` | Node Callout avec 4 types : info (bleu), success (vert), warning (orange), danger (rouge) |
| `assets/admin/extensions/columns.js` | Nodes Columns + Column pour layout 2 colonnes |

### Fonctionnalites implementees dans tiptap-editor.js

| Fonctionnalite | Description |
|----------------|-------------|
| **Toolbar enrichie** | B, I, U, S, Highlight, H2, H3, H4, Align L/C/R, Listes, Citation, Code, Callout, Colonnes, Lien, Image, Video, Separateur, Undo/Redo |
| **Slash commands `/`** | Menu popup contextuel avec 15 options (titres, image, video, citation, listes, 4 types d'encarts, colonnes, code, separateur). Filtrage par texte, navigation clavier (fleches + Enter), fermeture Echap |
| **Character count** | Barre de statut en bas avec compteur `X caracteres · Y mots` |
| **Callout menu** | Menu popup pour choisir le type d'encart (info, succes, attention, danger) |

### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `assets/admin/tiptap-editor.js` | Import extensions, toolbar enrichie, slash commands, callout menu, char count |
| `assets/admin/tiptap-editor.scss` | CSS slash menu, callout menu, status bar, char count |
| `assets/css/base/blocks.scss` | CSS front : `.block-callout` (4 variantes), `.block-columns`, `.block-highlight`, alignement |
| `src/Service/BlockRenderer.php` | Rendu HTML callout, columns, column, highlight, textAlign |
| `config/packages/html_sanitizer.yaml` | Autorisation `<div>` avec classes `block-callout*`, `block-column*`, `<mark>`, `style: text-align` |

### Helps CRUD editeur

Ajout d'un help mentionnant la commande `/` sur les 7 CRUDs utilisant l'editeur :
- ArticleCrudController, PageCrudController, ProductCrudController
- FaqCrudController, PortfolioItemCrudController, ServiceCrudController, EventCrudController

### Guide admin

Section **"Editeur de contenu"** ajoutee dans `templates/admin/guide/index.html.twig` :
- Mise en forme, blocs speciaux, medias, commande `/`, sauvegarde auto, compteur caracteres
- Sans mention du nom "TipTap" (transparent pour l'utilisateur)

---

## Decisions de design

- **FAQ** : pas de page detail individuelle `/faq/{slug}` — tout est sur `/faq` en accordeon. Le slug sert d'ancre (`#slug`) pour les liens directs.
- **Portfolio tags** : relies a la table `Tag` existante (ManyToMany) — partages avec blog et catalogue.
- **Portfolio vs Catalogue** : modules separes, pas de reutilisation. Un client peut avoir les deux sans conflit.
- **Nommage routes** : `/realisations` et `/realisation/{slug}` (francais, coherent avec `/evenements`, `/services`).
- **Colonnes mobile** : stack vertical automatique (`1fr`) sous 768px.
- **Slash commands** : implementation custom (pas `@tiptap/suggestion`) pour plus de simplicite et de controle.
- **Chemin medias** : `documents/medias/` (corrige partout depuis `uploads/medias/`).

---

## Phase 11 — Home generique + Fix build CSS

> Implemente le 2026-03-30

### Probleme resolu : home.scss non compile

Le fichier `assets/css/base/home.scss` etait **silencieusement ignore** par Webpack a cause d'un `@include btn-font` dans la section legacy `.headband`. Le mixin `btn-font` est defini dans `variables.scss` mais Sass echouait silencieusement lors de la compilation via Webpack (pas d'erreur affichee, le fichier entier etait skip).

**Fix** : remplacement de `@include btn-font` par le CSS equivalent inline (ligne ~541).

### Home generique (`_home_generic.html.twig`)

Objectif : **un seul template de home** partage par tous les themes. Le contenu est dans le template, le style vient du theme via CSS custom properties.

**Avant** : chaque theme avait son propre `home.html.twig` avec du contenu different en dur → changer de theme = perdre la home personnalisee.

**Apres** : `templates/home/_home_generic.html.twig` est utilise par tous les themes. Les fichiers `home.html.twig` par theme sont supprimes (sauf s'ils existent encore pour des raisons de compatibilite).

### Sections de la home generique

| Section | Source donnees | Condition d'affichage |
|---------|---------------|----------------------|
| Hero | `site.name`, `site.title`, `site.defaultSeoDescription`, `site.heroImage` | Toujours |
| Trust badges | Hardcode dans template | Toujours |
| Features (6 cards) | Hardcode dans template (icones SVG + textes) | Toujours |
| Services | Entity `Service` via `services` | Module `services` actif + donnees |
| Produits | Entity `Product` via `featuredProducts` | Module `catalogue` actif + donnees |
| Evenements | Entity `Event` via `upcomingEvents` | Module `events` actif + donnees |
| Portfolio | Entity `PortfolioItem` via `featuredPortfolio` | Module `portfolio` actif + donnees |
| FAQ | Entity `Faq` via `faqs` | Module `faq` actif + donnees |
| Metrics | Hardcode dans template | Toujours |
| Articles | Entity `Article` via `articles` | Module `blog` actif + donnees |
| A propos | `site.aboutImage`, `site.title`, `site.defaultSeoDescription` | Toujours |
| Galerie | `site.getGalleryBySlot('gallery')` | Images presentes |
| Temoignages | `site.getGalleryBySlot('testimonial')` | Temoignages presents |
| Logos clients | `site.getGalleryBySlot('logo')` | Logos presents |
| CTA final | Hardcode dans template | Toujours |

### CSS ajoute dans `home.scss`

| Classe | Role |
|--------|------|
| `.home-hero__badges` / `.home-hero__trust-badge` | Badges de confiance sous le hero |
| `.home-features` / `__grid` / `__card` / `__icon` / `__title` / `__desc` | Grille 3 colonnes de features avec icones SVG |
| `.home-metrics` / `__item` / `__value` / `__label` | Bande de chiffres cles (fond gradient) |

### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `templates/home/_home_generic.html.twig` | Template home generique complet |
| `templates/home/index.html.twig` | Include `_home_generic.html.twig` au lieu du template par theme |
| `assets/css/base/home.scss` | Ajout features, metrics, trust badges + fix mixin btn-font |

### Workflow client

1. Sur `main` : la home generique est le modele de base avec du contenu standard (features BlogWeb, metrics, trust badges)
2. Sur chaque branche `bw_*` : le contenu du template est personnalise (textes hero, features, metrics adaptees au client)
3. Le theme ne change que l'apparence via CSS — changer de theme ne perd plus le contenu de la home

### Important

- Les sections hardcodees (features, metrics, trust badges, CTA) sont destinees a etre personnalisees sur chaque branche client
- Les sections dynamiques (services, produits, FAQ, portfolio, articles) s'affichent automatiquement si le module est actif et contient des donnees
- Le hero utilise les champs `Site` (name, title, defaultSeoDescription, heroImage) — editables dans l'admin

---

## Phase 12 — Ameliorations UX Editeur + Tables TipTap

> Implemente le 2026-03-30

### 12.1 — Extension Tables TipTap ✓ TERMINE

| Package npm | Role |
|-------------|------|
| `@tiptap/extension-table` | Gestion des tableaux |
| `@tiptap/extension-table-row` | Lignes |
| `@tiptap/extension-table-cell` | Cellules |
| `@tiptap/extension-table-header` | En-tetes |

**Fonctionnalites :**
- Bouton toolbar `Inserer un tableau` (3x3 avec en-tete par defaut)
- Slash command `/tableau`
- **Barre contextuelle** sous la toolbar quand le curseur est dans un tableau : Col. avant/apres, Ligne avant/apres, En-tete, Fusionner, Scinder, Suppr. col./ligne/tableau
- Redimensionnement des colonnes (drag)
- Selection multi-cellules visuelle

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `assets/admin/tiptap-editor.js` | Import 4 extensions table, bouton toolbar, barre contextuelle, slash command, commandes table dans execCommand |
| `assets/admin/tiptap-editor.scss` | CSS `.tableWrapper`, `table th/td`, `.selectedCell`, `.column-resize-handle`, `.tiptap-table-contextbar` |
| `src/Service/BlockRenderer.php` | Rendu HTML nodes `table`, `tableRow`, `tableHeader`, `tableCell` avec `colspan`/`rowspan` |
| `config/packages/html_sanitizer.yaml` | Autorisation `<table>`, `<thead>`, `<tbody>`, `<tr>`, `<th>`, `<td>` avec `colspan`/`rowspan` |

### 12.2 — Suppression systeme draftBlocks ✓ TERMINE

Le champ `draftBlocks` (JSON, nullable) existait sur Article et Page mais n'etait **jamais utilise** — ni lu, ni ecrit. Le brouillon localStorage ("Brouillon trouve") a ete supprime aussi (source de confusion).

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `src/Entity/Article.php` | Suppression propriete `$draftBlocks` + getter/setter |
| `src/Entity/Page.php` | Suppression propriete `$draftBlocks` + getter/setter |
| `migrations/Version20260330175902.php` | `ALTER TABLE article DROP draft_blocks` + `ALTER TABLE page DROP draft_blocks` |
| `assets/admin/tiptap-editor.js` | Suppression systeme localStorage (setupAutosave, saveDraft, checkDraft, clearDraft, bandeau "Brouillon trouve") |
| `assets/admin/tiptap-editor.scss` | Suppression CSS `.tiptap-draft-banner` |

### 12.3 — Ctrl+S Save + Dirty State ✓ TERMINE

Remplace le systeme de draft par un save direct :

- **Ctrl+S / Cmd+S** declenche le submit normal du formulaire EasyAdmin
- **Indicateur** "Modifications non enregistrees" dans la barre de statut apres chaque edition
- **Alerte beforeunload** si des modifications ne sont pas sauvegardees

### 12.4 — Bouton "Voir sur le site" ✓ TERMINE

Action EasyAdmin ajoutee sur les CRUDs Page et Article :
- Visible sur les pages **INDEX** et **EDIT**
- Ouvre la page front dans un **nouvel onglet**
- Affiche uniquement si l'entite est **publiee**

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `src/Controller/Admin/PageCrudController.php` | Action `viewOnSite` avec `linkToUrl` + `target _blank` |
| `src/Controller/Admin/ArticleCrudController.php` | Idem + ajout `configureActions` |

### 12.5 — Picker de liens internes ✓ TERMINE

Remplacement du `prompt()` basique par une modale complete de selection de liens :

**Endpoint API :** `GET /admin/api/links?q=recherche`

Retourne les liens internes groupes par type :
- Pages publiees
- Articles publies
- Categories
- Services (si module actif)

**Modale TipTap :**
- Champ de recherche avec filtrage temps reel (debounce 200ms)
- Liste groupee par type (Pages, Articles, Categories, Services)
- Selection par clic, insertion par double-clic
- Support URL externe (detection auto `http`, `/`, `mailto:`)
- Checkbox "Nouvel onglet"
- Fermeture Echap / clic backdrop

**Fichiers crees :**

| Fichier | Role |
|---------|------|
| `src/Controller/Admin/Api/LinkApiController.php` | Endpoint API liens internes |

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `assets/admin/tiptap-editor.js` | Nouvelle methode `openLinkModal` + `loadInternalLinks` + `closeLinkModal` |
| `assets/admin/tiptap-editor.scss` | CSS `.tiptap-link-item` |

### 12.6 — Editeur pleine largeur ✓ TERMINE

Ajout `->setColumns('col-12')` sur le champ `blocksJson` de tous les CRUDs utilisant TipTap :
- ArticleCrudController, PageCrudController, ProductCrudController
- FaqCrudController, PortfolioItemCrudController, ServiceCrudController, EventCrudController

### 12.7 — Preview responsive dans l'editeur ✓ TERMINE

3 boutons en fin de toolbar : Bureau / Tablette / Mobile

| Mode | Largeur max | Details |
|------|-------------|---------|
| Desktop | 100% | Par defaut |
| Tablette | 768px | Bordures pointillees, centre |
| Mobile | 375px | Bordures pointillees, centre, font reduit |

**CSS :** `.tiptap-preview-tablet`, `.tiptap-preview-mobile`

### 12.8 — Fix slash command `/` ✓ TERMINE

La detection du `/` etait dans un second listener `editor.on('update')` enregistre dans `setupSlashCommands`, en plus du `onUpdate` du constructeur Editor. Consolidation dans une methode `handleSlashDetection()` appelee depuis le callback principal `onUpdate`.

---

### 12.9 — CSS Tableaux front (par theme) ✓ TERMINE

Styles CSS pour les tableaux TipTap rendus cote front. Deux couches :

**Base** (`assets/css/base/blocks.scss`) — `.tiptap-table` :
- `border-collapse: separate`, bordures `var(--border)`, `border-radius: var(--radius-md)`
- En-tetes : fond `var(--surface)`, uppercase, `var(--text-muted)`
- Zebra striping lignes paires (`color-mix` surface)
- **Liens → boutons** : `display: inline-block`, fond `var(--primary)`, texte blanc, hover `var(--secondary)` + lift `translateY(-1px)`
- Responsive : scroll horizontal sous 768px

**Overrides par theme** (chaque `templates/themes/*/theme.css`) :

| Theme | Personnalisation |
|-------|-----------------|
| `default` | Squelette commente (base client) |
| `corporate` | En-tetes serif (font-family-secondary), border-bottom 2px primary, boutons uppercase 0.25rem radius |
| `artisan` | Radius genereux 0.75rem, en-tetes teintes secondary, boutons pill (2rem radius), hover primary |
| `vitrine` | Boutons outline (transparent + border primary), en-tetes uppercase primary, hover rempli |
| `starter` | Minimaliste : pas de bordure table, pas de zebra, liens = texte souligne (pas de boutons) |
| `moderne` | Fond surface dark, en-tetes teintes primary, boutons gradient (primary→accent) avec glow shadow |

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `assets/css/base/blocks.scss` | Section `.tiptap-table` complete (base, en-tetes, zebra, liens-boutons, responsive) |
| `templates/themes/default/theme.css` | Commentaires squelette tables |
| `templates/themes/corporate/theme.css` | Override tables corporate |
| `templates/themes/artisan/theme.css` | Override tables artisan |
| `templates/themes/vitrine/theme.css` | Override tables vitrine |
| `templates/themes/starter/theme.css` | Override tables starter |
| `templates/themes/moderne/theme.css` | Override tables moderne |

---

## Phase 13 — Corrections & Harmonisation

> Implemente le 2026-03-31

### 13.1 — Favicons + Logos ✓ TERMINE

Remplacement complet des anciens logos/favicons par les nouveaux assets.

**Favicons** (7 fichiers dans `public/`) :
- `favicon.ico`, `favicon.svg`, `favicon-96x96.png`
- `apple-touch-icon.png`, `web-app-manifest-192x192.png`, `web-app-manifest-512x512.png`
- `site.webmanifest` (name: "Blog & Web", short_name: "BlogWeb")

**Logos** (3 fichiers dans `public/images/`) :
- `logo-blogweb.png` — theme clair (header)
- `logo-blogweb-white.png` — theme sombre (footer)
- `logo-blogweb.jpg` — fallback og:image / twitter:image

**Fichiers modifies :**

| Fichier | Modification |
|---------|-------------|
| `templates/base.html.twig` | Favicons SVG/PNG/ICO + apple-touch-icon + manifest + og:image/twitter:image fallback |
| 5x `_header.html.twig` | `BlogWebbeta-h150.png` → `logo-blogweb.png` |
| 5x `_footer.html.twig` | `BlogWebbeta - blanc.png` → `logo-blogweb-white.png` |

### 13.2 — Reset HR dans le contenu ✓ TERMINE

Les `<hr>` dans le contenu des pages/articles avaient un `border-top` Bootstrap visible. Ajout d'un reset `!important` dans `blocks.scss` pour `.content`, `.content_page`, `.page-detail__content`, `.article-detail__content`.

### 13.3 — Fix ResponsiveImageExtension ✓ TERMINE

Erreur `Undefined constant MediaUploadListener::RESPONSIVE_SIZES`. La constante est sur `MediaProcessorService`, pas `MediaUploadListener`.

| Fichier | Modification |
|---------|-------------|
| `src/Twig/ResponsiveImageExtension.php` | Import `MediaProcessorService` au lieu de `MediaUploadListener` |

### 13.4 — Cascade suppression Media (ON DELETE SET NULL) ✓ TERMINE

Supprimer un media causait une `ForeignKeyConstraintViolationException` car les FK n'avaient pas de `onDelete`. Ajout `#[ORM\JoinColumn(onDelete: 'SET NULL')]` sur toutes les relations ManyToOne vers Media.

**11 entites corrigees :**
- Article, Page, Categorie (`featured_media`)
- Service, Event, Product, ProductCategory, PortfolioItem (`image`)
- Site (`favicon`, `heroImage`, `aboutImage`)
- ProductImage (`media`) → `SET NULL`
- SiteGalleryItem (`media`) → `CASCADE` (un item galerie sans media n'a pas de sens)

| Fichier | Modification |
|---------|-------------|
| `migrations/Version20260331051133.php` | 26 ALTER TABLE pour ajouter ON DELETE SET NULL/CASCADE |

### 13.5 — Fix categorie/show.html.twig ✓ TERMINE

La page categorie incluait `article_liste_large.html.twig` avec une collection (`articles`) au lieu d'un article unique. Remplacement par une boucle `{% for article %}` avec `article/item.html.twig`.

### 13.6 — Templates user (show + edit) ✓ TERMINE

Les templates `user/show.html.twig` et `user/edit.html.twig` n'existaient pas → erreur 500 sur `/user/{id}`.

**Fichiers crees :**

| Fichier | Role |
|---------|------|
| `templates/user/show.html.twig` | Profil utilisateur (avatar, infos, abonnements, lien edit) |
| `templates/user/edit.html.twig` | Formulaire edition profil (nom, prenom, email, abonnements) |

### 13.7 — Harmonisation layout categorie + tag ✓ TERMINE

Les templates `categorie/show.html.twig` et `tag/show.html.twig` utilisaient un ancien pattern (`flex-column-reverse`, sidebar a gauche, pas de classes CSS de theme). Alignement sur le pattern standard de `page/show.html.twig` :

**Avant :** `d-flex flex-column-reverse flex-lg-row` > `col-lg-4` (sidebar) > `col-lg-8` (contenu)
**Apres :** `row` > `col-lg-8` > `.page-detail` > `.page-detail__title` + `.page-detail__content.article-detail__content` > `col-lg-4` > `.blog-sidebar`

Les overrides de theme s'appliquent maintenant automatiquement (`.page-detail__title`, `.article-detail__content`, `.blog-sidebar`).

| Fichier | Modification |
|---------|-------------|
| `templates/categorie/show.html.twig` | Layout row standard + classes page-detail + blog-sidebar + breadcrumb Blog |
| `templates/tag/show.html.twig` | Idem |

---

## Phase 14 — Systeme d'abonnement leger (sans compte)

> Implemente le 2026-03-31

### Contexte

L'ancien systeme de "notifications" etait lie a l'entite `User` — il fallait creer un compte, se connecter, aller dans son profil pour cocher des cases. Le widget sidebar redirigait vers "Creer un compte" pour les non-connectes → personne ne s'abonnait.

**Nouveau systeme** : light comme le panier e-commerce. Le visiteur donne son email, coche ce qui l'interesse, valide. Double opt-in par email. Desinscription en un clic. Aucun compte necessaire.

### Fichiers crees

| Fichier | Role |
|---------|------|
| `src/Entity/Subscriber.php` | Entite autonome (email, subscribeArticles, subscribeEvents, token, isActive, createdAt, confirmedAt) |
| `src/Repository/SubscriberRepository.php` | `findActiveArticleSubscribers`, `findActiveEventSubscribers`, `findByToken`, `findByEmail` |
| `src/Form/Type/SubscribeType.php` | Formulaire email + checkboxes conditionnels (modules actifs) + honeypot anti-spam |
| `src/Controller/SubscribeController.php` | POST subscribe, GET confirm/{token}, GET unsubscribe/{token}, GET/POST manage/{token}, widget() |
| `src/Controller/Admin/SubscriberCrudController.php` | CRUD admin lecture/edition/suppression avec filtres |
| `templates/widgets/_subscribe_form.html.twig` | Partial widget formulaire inline (rendu via sub-request) |
| `templates/subscribe/confirm.html.twig` | Page "Abonnement confirme" apres clic lien email |
| `templates/subscribe/unsubscribe.html.twig` | Page "Desabonnement effectue" avec option re-abonnement |
| `templates/subscribe/manage.html.twig` | Page gestion preferences via token (sans connexion) |
| `migrations/Version20260331120749.php` | Table `subscriber` avec index composites |

### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `templates/widgets/subscribe.html.twig` | Remplace par `render(controller('...SubscribeController::widget'))` |
| `src/Service/ArticleNotificationService.php` | Injecte SubscriberRepository + UrlGenerator, envoie aux Subscribers actifs, dedup par email, lien desinscription dans footer |
| `src/Service/EventNotificationService.php` | Idem — Subscribers events + lien desinscription |
| `src/Controller/Admin/DashboardController.php` | Menu "Abonnes" dans section Communaute |
| `config/packages/rate_limiter.yaml` | Ajout `subscribe_limiter` (5 requetes / 10 min) |
| `templates/themes/corporate/blog.html.twig` | Ajout widget subscribe dans la sidebar existante (col-lg-3) |
| `templates/themes/moderne/blog.html.twig` | Ajout bandeau subscribe inline apres pagination (col-lg-6, centre) |
| `templates/themes/starter/blog.html.twig` | Ajout bandeau subscribe inline apres pagination (col-lg-5, centre) |
| `templates/themes/vitrine/blog.html.twig` | Ajout bandeau subscribe inline apres pagination (col-lg-6, centre) |
| `assets/css/base/widgets.scss` | CSS formulaire dans `.widget_register` (inputs, checkboxes, placeholder sur fond colore/gradient) |
| `templates/themes/vitrine/theme.css` | Override `.widget_register` (fond surface, border, texte sombre) |
| `templates/themes/starter/theme.css` | Override `.widget_register` (fond transparent, inputs normaux, texte sombre) |

### Architecture

```
Visiteur → Widget sidebar/inline → POST /subscribe
    → Honeypot check → Rate limiting → Email existe ?
        → Nouveau : persist + email confirmation
        → Existant inactif : update preferences + renvoyer email
        → Existant actif : update preferences directement

Email confirmation → GET /subscribe/confirm/{token}
    → isActive = true, confirmedAt = now

Publication article/event (admin) → NotificationService
    → Subscribers actifs → email avec liens unsub + manage

Desinscription → GET /unsubscribe/{token}
    → isActive = false, flags reset

Gestion → GET /subscribe/manage/{token}
    → Formulaire pre-rempli, mise a jour preferences
```

### Integration par theme

| Theme | Pattern | Emplacement |
|-------|---------|-------------|
| **Default** | Sidebar col-lg-4 | blog.html.twig (deja present) |
| **Artisan** | Sidebar col-lg-4 | blog.html.twig (deja present) |
| **Corporate** | Sidebar col-lg-3 | blog.html.twig (ajoute en premier widget) |
| **Moderne** | Inline centre apres pagination | blog.html.twig (col-lg-6, fond gradient purple→cyan) |
| **Starter** | Inline centre apres pagination | blog.html.twig (col-lg-5, fond transparent, border fine) |
| **Vitrine** | Inline centre apres pagination | blog.html.twig (col-lg-6, fond surface, indigo accent) |

### CSS widget_register par theme

| Theme | Fond | Texte/inputs |
|-------|------|-------------|
| Base (widgets.scss) | `var(--gradient-primary)` | Blanc, inputs transparents rgba |
| Corporate | `var(--primary)` navy | Blanc (herite base) |
| Artisan | Gradient brown→sand | Blanc (herite base) |
| Moderne | Gradient purple→cyan | Blanc (herite base) |
| Starter | Transparent + border | Override : texte sombre, inputs normaux |
| Vitrine | `var(--surface)` + border | Override : texte sombre, inputs normaux |

### Securite et RGPD

- **Double opt-in** : le subscriber n'est actif qu'apres clic sur le lien de confirmation email
- **Token unique** (64 hex chars, `bin2hex(random_bytes(32))`) pour confirm, unsubscribe, manage
- **Honeypot** anti-spam (meme pattern que ContactType)
- **Rate limiting** 5 requetes / 10 min par IP
- **Desinscription en un clic** dans chaque email de notification
- **Gestion preferences** via lien tokenise (sans connexion)
- **UniqueEntity** sur email — pas de doublons en base

### Decisions d'implementation

- **Entite Subscriber separee de User** — pas de couplage. Un visiteur peut etre subscriber sans avoir de compte.
- **Pas de reCAPTCHA** sur le formulaire subscribe (present sur chaque page via sidebar → performance). Honeypot + rate limiting + double opt-in suffisent.
- **Widget via sub-request** `render(controller())` — le formulaire est cree par le controller, pas par une variable Twig globale.
- **Themes sans sidebar** (moderne, starter, vitrine) → bandeau inline centre apres pagination plutot que forcer une sidebar.
- **Themes avec sidebar** (default, artisan, corporate) → widget en premier dans la sidebar.

### 14.1 — Nettoyage ancien systeme (subscriptions sur User) ✓ TERMINE

> Implemente le 2026-03-31

Suppression complete de l'ancien systeme d'abonnement lie aux comptes utilisateur. Les NotificationServices n'utilisent plus que l'entite Subscriber.

#### Fichiers modifies

| Fichier | Modification |
|---------|-------------|
| `src/Entity/User.php` | Suppression 3 proprietes (`subscribeNews`, `subscribeArticles`, `subscribeEvents`) + 6 getters/setters |
| `src/Form/UserType.php` | Suppression champs `subscribeArticles`/`subscribeEvents`, imports `CheckboxType` et `SiteContext` retires |
| `src/Controller/Admin/UserCrudController.php` | Suppression champs admin `news` et `articles` (BooleanField) |
| `src/Repository/UserRepository.php` | Suppression methode `findSubscribersForEvents()` (inutilisee) |
| `src/Service/ArticleNotificationService.php` | Suppression branche User, uniquement SubscriberRepository, suppression import `UserRepository` |
| `src/Service/EventNotificationService.php` | Idem — uniquement SubscriberRepository |
| `templates/user/show.html.twig` | Suppression section "Abonnements" (badges Newsletter/Articles/Evenements) |
| `templates/user/edit.html.twig` | Suppression section "Notifications" (checkboxes subscribeArticles/Events) |
| `templates/event/show.html.twig` | Remplacement bloc ancien "Ne manquez rien" (lie a User) par `{% include 'widgets/subscribe.html.twig' %}` |

#### Fichiers supprimes

| Fichier | Raison |
|---------|--------|
| `templates/User/show.html.twig` | Template legacy orpheline (jamais referencee par un controller) |
| `templates/User/edit.html.twig` | Idem |
| `templates/User/edit_pass.html.twig` | Idem |
| `templates/User/find.html.twig` | Idem |

#### Migration

| Fichier | SQL |
|---------|-----|
| `migrations/Version20260331134753.php` | `ALTER TABLE user DROP subscribe_news, DROP subscribe_articles, DROP subscribe_events` |

#### Impact

- **User entity** ne porte plus aucune notion d'abonnement → responsabilite unique (authentification + profil)
- **NotificationServices** simplifie : une seule source de donnees (Subscriber), plus de dedup
- **4 templates legacy** `templates/User/` supprimees (non referencees, remplacees par `templates/user/` depuis Phase 13.6)
- **event/show.html.twig** utilise maintenant le meme widget subscribe que le reste du site

---

## Recap packages npm ajoutes (Phase 12)

```
@tiptap/extension-table@^2.27.2
@tiptap/extension-table-row@^2.27.2
@tiptap/extension-table-cell@^2.27.2
@tiptap/extension-table-header@^2.27.2
@popperjs/core (dependance Bootstrap)
```
