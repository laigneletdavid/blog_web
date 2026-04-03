# Blog & Web — CMS Symfony

## Objectif

CMS Symfony pret a vendre. Un site propre, securise, avec SEO integre, clonable en 30 minutes pour chaque nouveau client. On vend du service (installation + personnalisation), pas du SaaS.

## Stack technique

- **Backend** : PHP 8.4 / Symfony 7.4 LTS
- **ORM** : Doctrine ORM 3.3 + Migrations
- **Admin** : EasyAdmin Bundle 4.12
- **Frontend** : Webpack Encore + Bootstrap 5.3 + Stimulus/Hotwire
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
| `.claude/docs/` | Archives dev (spec historique, roadmap, design) — supprimes chez les clients |

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

## Contraintes prod (OVH mutualise)

- **MariaDB local ≠ MySQL 8 prod** : le script `--import` convertit automatiquement (collation, sandbox mode, JSON DEFAULT)
- **Pas de .env.prod** dans le repo : ecrase les valeurs de .env.local. Supprime automatiquement par le script.
- **APP_ENV=prod** doit etre exporte avant toute commande Symfony (auto-scripts composer)
- **Node.js ancien sur OVH** : le script installe nvm + Node 20 automatiquement
- **Ports bloques sur OVH** : le script patche sync-rpc automatiquement
- **Pas de Docker sur OVH mutualise** : tout passe par deploy-ovh.sh

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
│   ├── Entity/              # Doctrine entities
│   ├── Service/             # SiteContext, ThemeService, SeoService, etc.
│   └── EventSubscriber/     # PageViewSubscriber, ContentSanitize, etc.
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
