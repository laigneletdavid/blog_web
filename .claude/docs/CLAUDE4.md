# CLAUDE4 — Backlog technique

## Fait

### Favicon auto-generation depuis le logo (CRUD Site)
**Statut** : FAIT (commit 6f9fa04)
- `FaviconGeneratorService` : genere 7 favicons PNG (16, 32, 96, 150, 180, 192, 512) + `site.webmanifest` + `browserconfig.xml`
- `SiteLogoListener` (postPersist/postUpdate) : regenere a chaque sauvegarde du Site
- Champ `logoDark` (ManyToOne Media, nullable) pour le footer fond sombre
- `base.html.twig` : package favicon complet, plus de condition if/else
- 5 footers themes : `site.logoDark ?? site.logo` fallback
- SiteCrudController : sous-sections (Nom, Visuels, Coordonnees), champ favicon manuel supprime

### Systeme d'override client templates/client/
**Statut** : FAIT
- Priorite : client/ > themes/{theme}/ > themes/default/
- 5 includes mis a jour (header, footer, home, contact, blog)
- ThemeService.hasClientTemplate() ajoute
- .gitignore sur main, trackable sur branches bw_* via `git add -f`

### Fix categories portfolio ecrasees par base.html.twig
**Statut** : FAIT (commit 86cca12)
- Variable `categories` dans PortfolioController renommee en `portfolioCategories`
- `base.html.twig` ligne 7 ecrasait la variable avec les categories blog (widget)

### Module Annuaire (DirectoryEntry + DirectoryCategory)
**Statut** : FAIT
- Entites : `DirectoryEntry` (firstName, lastName, slug, photo, jobTitle, company, bio, email, phone, city, website, linkedin, facebook, instagram, category, user, isActive, isFeatured, SeoTrait) + `DirectoryCategory`
- Repositories : findAllActive, findActiveByCategory, searchActive, findFeatured, findByUser, findAllActiveForSitemap
- Admin CRUDs : DirectoryEntryCrudController (5 panels + ImageField direct) + DirectoryCategoryCrudController — avec getHelpData()
- DashboardController : menu Annuaire (Fiches + Categories)
- Front controller : `/annuaire` (liste + filtres categorie + recherche), `/annuaire/{slug}` (fiche detail 2 colonnes + sidebar), `/annuaire/ma-fiche` (edition membre connecte)
- Form : DirectoryEntryType avec upload photo
- Templates : index (filtres pills + search + grille cards), show (layout 2 colonnes blog-like + sidebar contact/liens), card (entreprise en titre, "En savoir plus"), edit (formulaire membre)
- CSS : `directory.scss` enrichi (cards, filtres, detail, sidebar sticky) + overrides par theme dans chaque theme.css
- Overrides theme : Corporate (horizontal, serif, uppercase), Artisan (gros radius, terre, serif), Vitrine (epure, outline, letter-spacing), Starter (liste brut, pas de cards, opacity hover), Moderne (dark mode, gradient, glow)
- Sitemap : entrees directory integrees
- Bootstrap Icons : installe via npm, importe dans main.scss

### Bootstrap Icons
**Statut** : FAIT
- `npm install bootstrap-icons`
- Import dans `assets/css/main.scss` : `@import "~bootstrap-icons/font/bootstrap-icons.css"`
- Utilise pour les icones categories (annuaire + portfolio) et les icones de la fiche detail
