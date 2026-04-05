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

### Optimisation performances PageSpeed (commit d780414)
**Statut** : FAIT
- **Dockerfile** : ajout `libwebp-dev` + `--with-webp` — GD ne supportait pas WebP, toute la conversion echouait silencieusement
- **ResponsiveImageExtension** : parametre `eager` pour les images LCP (`loading="eager" fetchpriority="high"`)
- **Homepage** : hero + about utilisent `responsive_img()` avec srcset WebP au lieu des JPG bruts
- **`.htaccess`** : cache 1 an immutable + gzip pour OVH Apache (le .htaccess Symfony par defaut n'avait aucun header cache)
- **`base.html.twig`** : Google Fonts en preload non-blocking + `display=swap`
- **`webpack.config.js`** : corejs mis a jour de 3.23 a 3.30
- **`.browserslistrc`** : ciblage navigateurs modernes pour reduire les polyfills (~58 Ko)
- Resultats : WebP fonctionne, responsive_img() actif, Google Fonts non-blocking, cache .htaccess en place
- **Score actuel** : Mobile 72, Desktop ~90

## A faire

### Performances PageSpeed — problemes restants
**Priorite** : Haute
**Score mobile actuel** : 72 (objectif > 90)

**Probleme principal : `/theme-css/vitrine` bloque 10.4s**
- Route Symfony dynamique qui genere le CSS du theme a chaque requete
- Cree une chaine critique de 10.4s sur mobile
- **Solution** : servir le theme.css en fichier statique pre-genere au lieu d'une route Symfony, ou inliner le CSS critique

**Bootstrap Icons trop lourd (13.4 Ko CSS inutilise)**
- Charge les 1800+ icones alors qu'on en utilise ~10
- Ajoute un fichier CSS render-blocking supplementaire (`373.971dca9d.css`)
- **Solution** : passer en SVG inline pour les icones utilisees, ou extraire uniquement les icones necessaires

**Logos PNG surdimensionnes (42 Ko inutiles)**
- `logo-blogweb.png` et `logo-blogweb-white.png` : 682x554 affiches en 78x63
- **Solution** : generer des versions optimisees (WebP, taille reelle) dans le FaviconGeneratorService ou manuellement

**JS inutilise (~79 Ko)**
- `512.dd4ea596.js` (core-js polyfills) : 58 Ko
- `373.bf2fc378.js` : 20 Ko
- **Solution** : verifier si `.browserslistrc` est bien pris en compte en prod, investiguer les imports inutiles
