# CLAUDE.md — BlogWeb CMS

## Stack
PHP 8.4 / Symfony 7.4 LTS / Doctrine ORM 3.3 / EasyAdmin 4.12 / TipTap /
Webpack Encore + Bootstrap 5.3 + Stimulus / Twig 3 / MariaDB 11 /
Docker (PHP-FPM + Nginx + Mailpit) / Brevo / Stripe (optionnel)

## Regles dures
- Aucun secret dans les fichiers suivis. `.env.local` est dans `.gitignore`.
- Code CMS sur `main` uniquement. Branches `bw_*` = clients.
- Ne jamais merger `bw_*` dans `main`. Merge `main` -> `bw_*` pour les mises a jour.
- Sur `bw_*` : supprimer CLAUDE.md et STATE.md (pas de fichiers dev chez les clients).
- Commits : conventional commits (`feat(scope):`, `fix(scope):`, `docs:`), messages en francais sans accents.
- Injection via constructeur `readonly`. Attributs `#[Route]` pour le routing.
- Contenus destines aux visiteurs : francais avec accents.
- Apres toute modif : relire le diff, verifier que ca tourne, corriger avant de rendre la main.

## Orientation rapide
- **README.md** : features, stack, architecture, commandes, workflow agent complet
- **SETUP.md** : installation nouveau client pas a pas
- **DEPLOY_REFERENCE.md** : deploiement OVH mutualise, troubleshooting
- **SEO.md** : plan SEO (termine, 3 phases)
- **STATS.md** : plan stats (termine, phases 1-5c)
- **client_reference_template.md** : fiche a remplir pour chaque client

## Modules (actives via `ModuleEnum` + `SiteContext::hasModule()`)
blog, services, catalogue, ecommerce, events, directory, faq, portfolio, pages privees, marketing

## Patterns cles
- Admin : CrudControllers EasyAdmin + `AdminHelpTrait` pour l'aide contextuelle
- SEO : `SeoTrait` partage sur les entites indexables
- Themes : fallback Twig `client/` > `themes/X/` > `default/`
- Stats : PageView + StatSession + StatConversion, IP hashee RGPD, cookie `_bw_sid`
- Frontend : SCSS par feature dans `assets/css/base/`, Stimulus controllers dans `assets/controllers/`
- Landing : layout `base_landing.html.twig` (sans nav), `LandingCrudController` separe de `PageCrudController`, `LandingContactType` avec UTM + honeypot

## Dette connue
- Zero tests (tests/ vide)
- `SiteContext::find(1)` hardcode (multi-tenant prevu mais pas implemente)
