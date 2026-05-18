# Blog & Web — CMS Symfony

## Regle n°1 — Ecouter l'utilisateur

David a 15 ans d'experience en developpement. Quand il dit qu'un truc ne marche pas, c'est que ca ne marche pas. Ne jamais remettre en question son diagnostic en se fiant uniquement aux outputs. Il connait son infra, son workflow, ses branches, les pieges OVH. Lui apporte la vision, la logique et l'anticipation. Claude apporte la vitesse d'execution et le volume. Les deux ensemble sont tres bons — mais seulement si Claude ecoute quand David corrige.

## Objectif

CMS Symfony pret a vendre. Un site propre, securise, avec SEO integre, clonable en 30 minutes pour chaque nouveau client. On vend du service (installation + personnalisation), pas du SaaS.

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS
- **ORM** : Doctrine ORM 3.3 + Migrations
- **Admin** : EasyAdmin Bundle 4.12
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Bootstrap Icons + Stimulus/Hotwire
- **Templates** : Twig 3
- **BDD locale** : MariaDB 11 (Docker)
- **BDD prod** : MySQL 8 (OVH CloudDB)
- **Infra dev** : Docker (PHP-FPM 8.4 + Nginx + MariaDB 11 + Mailpit)
- **Infra prod** : OVH mutualise
- **Mailer** : Brevo (via `symfony/brevo-mailer`)

## Documentation

| Fichier | Role |
|---------|------|
| `CLAUDE.md` | **Reference technique** — conventions, architecture, git, contraintes |
| `SETUP.md` | **Process client** — installation locale, setup, modules, personnalisation admin |
| `DEPLOY_REFERENCE.md` | **Process deploiement** — deploy OVH, --init, --import, checklist, problemes connus |
| `.claude/docs/CLAUDE4.md` | **Backlog technique** — taches faites et a faire |
| `.claude/docs/CLAUDE_FULL.md` | Spec complete originale (historique) |
| `.claude/docs/SPEC.md` | Spec modules et fonctionnalites |
| `.claude/docs/DESIGN_THEME.md` | Spec systeme de themes |
| `.claude/docs/PLAN.md` | Roadmap et planification |
| `.claude/docs/` | Archives dev — supprimes chez les clients |

> **Priorite de reference** : DEPLOY_REFERENCE.md et deploy-ovh.sh sont les documents les plus recents et font autorite sur le deploiement. En cas de contradiction avec SETUP.md ou d'autres docs, c'est DEPLOY_REFERENCE.md qui prime.

## Architecture Git

```
main                    ← CMS commun, jamais en prod
  ├── bw_front          ← Site BlogWeb (premier client)
  ├── bw_client2        ← Futur client
  └── bw_client3        ← Futur client
```

### Regles strictes

- **main** = tronc commun CMS. Jamais deploye. Features et fixes CMS ici.
- **bw_*** = branches clients. Deployees en prod. Contenu specifique client.
- **Merge, JAMAIS rebase** : `git checkout bw_xxx && git merge main`
- **Jamais** merger bw_* dans main. Main ne recoit jamais de code client.
- **Jamais** modifier les fichiers CMS (controllers, entities, services, templates themes) sur une branche client.

### Mise a jour client quand main evolue

```bash
git checkout bw_nom_client
git merge main              # Zero conflit si regles respectees
git push origin bw_nom_client
```

### Ce qui va sur chaque branche

| Fichier | main | bw_* |
|---------|------|------|
| src/ (controllers, entities, services) | Oui | **Non** |
| templates/themes/ (headers, footers) | Oui | **Non** |
| templates/client/ (overrides) | Vide (.gitkeep) | Oui (`git add -f`) |
| config/, docker/, Makefile | Oui | **Non** |
| public/documents/medias/ (images client) | Non | Oui |
| public/documents/files/ (PDF/docs client) | Non | Oui |
| .github/workflows/deploy.yml | Non | Oui (trigger par branche) |
| scripts/bw_*_dump.sql (dump BDD) | Non | Oui (temporaire) |

## Override templates client

Priorite de chargement Twig (automatique) :

```
1. templates/client/        ← Override client (si existe)
2. templates/themes/{theme}/ ← Template du theme actif
3. templates/themes/default/  ← Fallback
```

Templates overridables : `_header.html.twig`, `_footer.html.twig`, `home.html.twig`, `contact.html.twig`, `blog.html.twig`

Pour creer un override sur une branche client :
```bash
cp templates/themes/vitrine/_header.html.twig templates/client/_header.html.twig
# Modifier le fichier
git add -f templates/client/_header.html.twig
```

Sur main, `templates/client/` est gitignore (vide). Sur les branches bw_*, les fichiers sont force-trackes.

## Conventions de code

### General
- PHP 8.4, typed properties, readonly, enums
- Symfony 7.4 LTS, attributs PHP 8 (`#[Route]`, `#[ORM\Entity]`, `#[Assert\...]`)
- PascalCase classes, camelCase methodes/variables, snake_case BDD

### Architecture
- **Jamais** `->find(1)` → `SiteContext::getCurrentSite()`
- **Jamais** `findAll()` dans les controllers → methodes Repository
- **Toujours** ownership check avant modif d'une ressource utilisateur
- **Toujours** `HtmlSanitizer` sur contenu rendu avec `|raw`
- **Toujours** verifier `site.owner` pour les actions ROLE_FREELANCE
- **Tags partages multi-modules** (Article, Page, DirectoryEntry, Product, PortfolioItem, Categorie, Media). Regroupables en **Familles de tags** (`TagGroup`) pour generer des filtres front automatiques (ex: Villes / Metiers sur l'annuaire). Le rattachement a une famille est optionnel — `tag.tagGroup = null` reste valide.

### Securite
- CSRF active globalement
- `denyAccessUnlessGranted()` sur toute route sensible
- Password min 12 caracteres, hash `auto`
- reCAPTCHA v3 optionnel sur le formulaire de contact
- Verification email obligatoire (ROLE_ADMIN+ exempt)

### Roles

```
ROLE_USER < ROLE_AUTHOR < ROLE_ADMIN < ROLE_FREELANCE < ROLE_SUPER_ADMIN
```

| Role | Qui | Acces |
|------|-----|-------|
| `ROLE_USER` | Visiteur inscrit | Lecture, commentaires, profil |
| `ROLE_AUTHOR` | Redacteur | Creation/edition articles et pages |
| `ROLE_ADMIN` | Admin client | Gestion complete du site |
| `ROLE_FREELANCE` | Freelance revendeur | Themes, apparence, gestion multi-site |
| `ROLE_SUPER_ADMIN` | David | Acces total, modules, infrastructure |

### Front
- SCSS avec CSS custom properties (pas de couleurs hardcodees)
- Stimulus pour le JS interactif
- Bootstrap 5 personnalise via custom properties
- `loading="lazy"` systematique sur les images
- Images responsives WebP auto (480w, 800w, 1200w)

## Performances

### Images WebP + responsive
- `MediaProcessorService` convertit en WebP (85%) + genere 3 tailles responsives (480w, 800w, 1200w)
- `responsive_img()` Twig : srcset WebP automatique, param `eager` pour les images LCP
- **Docker** : `libwebp-dev` + `--with-webp` requis dans le Dockerfile (sinon GD echoue silencieusement)
- `app:media:regenerate-sizes --force` pour regenerer toutes les images existantes

### Cache HTTP
- **`.htaccess`** : `Expires` 1 an + `Cache-Control: public, max-age=31536000, immutable` sur tous les assets
- **Gzip** : active via `mod_deflate` sur HTML, CSS, JS, SVG, fonts
- Les assets Webpack ont des noms hashes en prod (`enableVersioning`)

### Google Fonts
- Charge en non-blocking (`preload` + `onload`) avec `display=swap`
- Preconnect vers `fonts.googleapis.com` et `fonts.gstatic.com`

### Polyfills
- `.browserslistrc` : cible `> 0.5%, last 2 versions, not dead, not ie 11`
- `corejs: '3.30'` avec `useBuiltIns: 'usage'` (tree-shaking)

## Contraintes prod (OVH mutualise)

- **MariaDB local ≠ MySQL 8 prod** : le script `--import` convertit automatiquement (collation, sandbox mode, JSON DEFAULT)
- **Pas de .env.prod** dans le repo : ecrase les valeurs de .env.local. Supprime automatiquement par le script.
- **APP_ENV=prod** doit etre exporte avant toute commande Symfony (auto-scripts composer)
- **Node.js ancien sur OVH** : le script installe nvm + Node 20 automatiquement
- **Ports bloques sur OVH** : le script patche sync-rpc automatiquement
- **Pas de Docker sur OVH mutualise** : tout passe par deploy-ovh.sh

## Documents (fichiers telechargeables)

Module dedie pour fichiers integrables dans l'editeur TipTap (PDF, DOCX, XLSX, PPTX, ODT/ODS/ODP, ZIP/RAR/7Z, CSV, TXT — max 25 Mo).

- **Entite** `Document` (id, name, file_name, extension, mime_type, size, created_at) — separee de `Media` (qui reste image-only avec son pipeline WebP)
- **Stockage** : `public/documents/files/` (separe de `medias/` pour eviter le mix images/docs)
- **`DocumentService`** : `formatSize()` (1,2 Mo / 340 Ko), `iconForExtension()` (mappe vers `fa-file-pdf`, `fa-file-word`, `fa-file-excel`, `fa-file-archive`, etc.), `MAX_FILE_SIZE_BYTES`, `ALLOWED_EXTENSIONS`
- **`DocumentMetadataListener`** (postPersist/postUpdate) : extrait mime/size/extension du fichier sur disque apres upload, auto-flush
- **`DocumentApiController`** : `/admin/api/document/list?q=` + `/admin/api/document/upload` (POST multipart, upload direct depuis l'editeur)
- **CRUD admin** : `DocumentCrudController` (FileUploadType + AdminHelpTrait, ROLE_AUTHOR)
- **Bouton TipTap** : icone `fa-file-arrow-down` dans la toolbar + commande slash `/document`. Modal avec liste + zone d'upload integree.
- **Extension TipTap** : `assets/admin/extensions/document.js` — node `document` block-level atom. Render carte HTML `<a class="block-document">` avec icone + nom + meta + action download.
- **Render serveur** : `BlockRenderer::renderDocument()` produit le meme markup pour le HTML cache (sanitizer-friendly)
- **HtmlSanitizer** (`config/packages/html_sanitizer.yaml`) : `a[class, href, target, rel, download, data-document-id, data-extension]` + `i[class]`
- **Front** : carte stylee dans `assets/css/base/blocks.scss` (`.block-document` avec custom properties theme)

## Walkthrough (visite guidée admin)

Tour interactif intégré au dashboard admin via **Driver.js** (~5 ko). Adaptatif selon le rôle utilisateur et les modules actifs du site.

### Architecture

| Composant | Fichier | Rôle |
|-----------|---------|------|
| Service PHP | `src/Service/WalkthroughService.php` | Génère les steps filtrés par rôle (`Security::isGranted`) et modules (`SiteContext::hasModule`) |
| Entry JS | `assets/admin/admin-walkthrough.js` | Initialise Driver.js, gère expand submenus, marque le tour complet en AJAX |
| Styles | `assets/admin/admin-walkthrough.scss` | Override CSS du popover Driver.js (reset text-shadow EasyAdmin) |
| Persistance | `User::tourCompleted` (bool) | Stocke si l'utilisateur a terminé le tour |
| Endpoints | `POST /admin/api/tour/complete` | Marque le tour comme vu |
|  | `POST /admin/api/tour/reset` | Remet le tour à zéro |

### Ancres CSS sur les MenuItems

Les éléments du menu admin ont des classes `tour-menu-*` via `->setCssClass()` dans `DashboardController::configureMenuItems()` :

`tour-menu-dashboard`, `tour-menu-visit-site`, `tour-menu-blog`, `tour-menu-pages`, `tour-menu-medias`, `tour-menu-documents`, `tour-menu-classification`, `tour-menu-modules-section`, `tour-menu-site-identity`, `tour-menu-navigation`, `tour-menu-apparence`, `tour-menu-theme-catalog`, `tour-menu-guide`

### Steps par rôle

| Étape | AUTHOR | ADMIN | FREELANCE | SUPER_ADMIN |
|-------|:------:|:-----:|:---------:|:-----------:|
| Dashboard (KPIs, tips, actions rapides) | ✓ | ✓ | ✓ | ✓ |
| Blog (si module actif) | ✓ | ✓ | ✓ | ✓ |
| Pages, Médias, Documents | ✓ | ✓ | ✓ | ✓ |
| Classification (Tags, Familles) | — | ✓ | ✓ | ✓ |
| Modules actifs | — | ✓ | ✓ | ✓ |
| Identité du site, Navigation | — | ✓ | ✓ | ✓ |
| Apparence (expand submenu auto) | — | ✓ | ✓ | ✓ |
| Voir le site, Guide | ✓ | ✓ | ✓ | ✓ |

### Déclenchement

- **Bannière** « Première visite ? » affichée si `tourCompleted == false`
- **Bouton** « Visite guidée » toujours présent dans les Actions rapides du dashboard
- Les sous-menus EasyAdmin ciblés (Apparence) s'ouvrent automatiquement au lancement et se referment à la fin

### Maintenance

Les steps sont couplés aux sélecteurs CSS du menu EasyAdmin. Si un `MenuItem` est ajouté/supprimé/renommé dans `configureMenuItems()`, mettre à jour :
1. La classe `->setCssClass('tour-menu-xxx')` sur le MenuItem
2. Le step correspondant dans `WalkthroughService::getStepsForCurrentUser()`

## Favicon auto-generation

Quand l'admin sauvegarde le Site avec un logo, `SiteLogoListener` declenche `FaviconGeneratorService` qui genere automatiquement :
- 7 favicons PNG (16, 32, 96, 150, 180, 192, 512) dans `public/`
- `public/site.webmanifest` (nom du site, couleur primaire, icones PWA)
- `public/browserconfig.xml` (Windows tiles)

Le champ `Site.logoDark` (optionnel) est utilise dans les footers : `site.logoDark ?? site.logo`.

Le champ favicon manuel a ete supprime du CRUD Site.

## Mailer (Brevo centralise)

Un seul compte Brevo pour tous les sites BlogWeb. Le transport utilise l'API HTTP (`brevo+api://`), pas SMTP.

- **`SystemMailerService`** : service centralise pour tous les envois mail
  - `from` : `noreply@comwebsolutions.fr` (expediteur unique verifie dans Brevo)
  - `reply-to` : dynamique, l'email du site client (pour que les reponses arrivent chez le bon client)
  - Nom d'affichage : le nom du site client
- **DSN** : `MAILER_DSN=brevo+api://CLE_API@default` dans `.env.local` de chaque site
- **Variables optionnelles** : `MAILER_SENDER_EMAIL` et `MAILER_SENDER_NAME` (defaut: `noreply@comwebsolutions.fr` / `ComWeb Solutions`)
- **Messenger** : mails en **sync** (pas de queue async — jamais consommee sur OVH mutualise)
- **Config** : `mailer.yaml` definit `envelope.sender` + `headers.From` globalement
- **Contrainte OVH** : les ports sortants (443, 465, 587) sont bloques en **SSH/CLI** mais ouverts depuis le **serveur web** (PHP-FPM/CGI). `mailer:test` en CLI echouera toujours sur OVH mutualise.
- **Contrainte Brevo** : restriction IP activee — chaque IP serveur doit etre autorisee dans Brevo → Parametres → Securite → IPs autorisees
- **DNS requis** : SPF (`include:spf.brevo.com`), DKIM (CNAME `brevo1._domainkey` + `brevo2._domainkey`), DMARC

Fichiers concernes : `SystemMailerService`, `HomeController`, `ResetPasswordController`, `RegistrationController`, `SubscribeController`, `CheckoutController`, `ArticleNotificationService`, `EventNotificationService`.

## Deploiement (deploy-ovh.sh)

Script unique `scripts/deploy-ovh.sh` avec 3 modes. Detail complet dans `DEPLOY_REFERENCE.md`.

| Mode | Usage |
|------|-------|
| `--init` | Premier deploy : collecte interactif BDD, genere `.env.local`, import dump optionnel |
| `--import dump.sql` | Import standalone avec conversion auto MariaDB → MySQL 8 |
| Normal | Mise a jour : pull + composer + assets + cache + migrations |

### Problemes connus (auto-corriges)

| Probleme | Correction auto |
|----------|-----------------|
| JSON DEFAULT echoue | `--import` supprime les contraintes |
| Collation incompatible (`_uca1400_`) | `--import` convertit en `_unicode_` |
| `.env.prod` ecrase config | Supprime par le script |
| sync-rpc bloque (ports OVH) | Patch eslint.js automatique |
| `DebugBundle not found` | Export `APP_ENV=prod` auto |

## Commandes

### Dev (local Docker)

```bash
make up              # Lance Docker
make down            # Stop
make sh              # Shell PHP
make db              # Reset BDD (drop + create + migrate)
make db-dump         # Dump BDD (lit le nom depuis .env.local)
make migrate         # Migrations seulement
make assets          # npm run dev
make assets-build    # npm run build (prod)
make cc              # Cache clear
```

### Prod (OVH)

```bash
./scripts/deploy-ovh.sh --init              # Premier deploy (genere .env.local + deploy + import dump)
./scripts/deploy-ovh.sh --import dump.sql   # Import dump (conversion MariaDB→MySQL auto)
./scripts/deploy-ovh.sh                     # Mise a jour (pull + build + cache + migrations)
```

### Symfony CLI

```bash
app:client:setup                    # Setup complet (site + admin + pages legales + menus)
app:module:enable <module>          # Active un module (blog, services, catalogue, ecommerce, events, directory, faq, portfolio)
app:module:disable <module>         # Desactive un module
app:recaptcha:setup                 # Configure reCAPTCHA v3
app:menu:sync                       # Resync menus apres changement theme
app:legal-pages:update              # Regenere pages legales
app:media:regenerate-sizes          # Regenere tailles WebP
```

## Structure

```
blog_web/
├── docker/                  # Dockerfile, nginx, php.ini
├── scripts/                 # deploy-ovh.sh, backup.sh, deploy.sh
├── assets/                  # JS/SCSS (app + admin entries)
├── src/
│   ├── Command/             # CLI (client:setup, module:enable, etc.)
│   ├── Controller/Admin/    # CrudControllers EasyAdmin
│   ├── Entity/              # Doctrine entities (Site, Media, Article, Page, DirectoryEntry, PortfolioItem, etc.)
│   ├── Form/                # DirectoryEntryType (edition membre)
│   ├── Service/             # SiteContext, ThemeService, FaviconGeneratorService, MediaProcessorService
│   ├── EventListener/       # MediaUploadListener, SiteLogoListener, ContentSanitize
│   └── EventSubscriber/     # PageViewSubscriber, AdminSubscriber
├── templates/
│   ├── client/              # Overrides client (vide sur main, rempli sur bw_*)
│   ├── themes/              # 6 themes (default, corporate, artisan, moderne, vitrine, starter)
│   ├── admin/               # Dashboard, guide, menu manager
│   └── ...                  # Front templates
├── .claude/docs/            # Spec technique (dev only, supprime chez clients)
├── SETUP.md                 # Process installation client
├── DEPLOY_REFERENCE.md      # Process deploiement OVH
└── README.md                # Presentation du projet
```
