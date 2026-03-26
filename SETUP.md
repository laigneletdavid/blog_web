# Installation d'un nouveau site client

## Prerequis

- Docker + Docker Compose
- Git
- Un compte Google (pour reCAPTCHA)
- Un compte Brevo (pour les emails transactionnels)

## Process rapide

```bash
# 1. Creer la branche client depuis master
cd ~/projects/blog_web
git checkout master
git checkout -b client/nom-du-client

# 2. Configurer l'environnement
cp .env.local.example .env.local
# Editer : APP_SECRET, DATABASE_URL, MAILER_DSN

# 3. Lancer + creer la BDD + builder les assets
make up && make db && make assets

# 4. Setup complet (site + admin + pages legales + menus)
docker compose exec php php bin/console app:client:setup

# 5. Activer les modules
docker compose exec php php bin/console app:module:enable blog

# 6. Configurer reCAPTCHA
docker compose exec php php bin/console app:recaptcha:setup

# 7. Personnaliser (templates, CSS, contenu)
# Les modifications custom du client se font sur cette branche

# 8. Vider le cache
docker compose exec php php bin/console cache:clear
```

Le site est pret sur http://localhost:8080/admin

---

## Detail des etapes

### 1. Creer la branche client

Chaque client a sa propre branche git, creee depuis `master`. Cela permet de personnaliser librement les templates, le CSS et la structure tout en recevant les mises a jour du CMS via `git merge master`.

```bash
cd ~/projects/blog_web
git checkout master
git pull origin master
git checkout -b client/nom-du-client
```

Convention de nommage : `client/nom-du-client` (ex: `client/boulangerie-martin`, `client/garage-dupont`).

> **Pour le deploiement en production**, cloner le repo et checkout la branche client :
> ```bash
> git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
> cd /var/www/clients/client-x
> git checkout client/nom-du-client
> ```

### 2. Configurer l'environnement

```bash
cp .env.local.example .env.local
```

Editer `.env.local` :
- `APP_SECRET` : generer une cle unique (`openssl rand -hex 32`)
- `DATABASE_URL` : adapter le nom de la BDD pour ce client (`blog_client_x`)
- `MAILER_DSN` : cle API Brevo pour les emails transactionnels

> **Note pour Claude Code / agent :** les 3 valeurs ci-dessus doivent etre fournies par l'utilisateur ou generees. `APP_SECRET` peut etre genere avec `openssl rand -hex 32`. `DATABASE_URL` doit avoir un nom de BDD unique par client. `MAILER_DSN` necessite un compte Brevo.

### 3. Lancer Docker + BDD + Assets

```bash
make up          # Lance les containers (PHP, Nginx, MariaDB, Mailpit)
make db          # Drop + Create + Migrate (BDD vierge)
make assets      # Build Webpack (CSS + JS)
```

Verifier que tout tourne : `docker compose ps`

### 4. Setup client

```bash
docker compose exec php php bin/console app:client:setup
```

Cette commande unique fait tout :
1. **Cree le site** — nom, email de contact, telephone
2. **Cree le super admin** — email, mot de passe (min 12 car.), nom, prenom
3. **Cree les pages legales** — mentions legales, politique de confidentialite
4. **Synchronise les menus** — header, footer navigation, footer legal
5. **Nettoie les fichiers dev** — supprime CLAUDE*.md, PLAN.md, DESIGN_THEME.md, audit, .claude/docs/

La commande est **idempotente** : si le site ou l'admin existent deja, ces etapes sont ignorees.

Mode non-interactif (pour scripts ou agents) :
```bash
docker compose exec php php bin/console app:client:setup \
  --site-name="Mon Site" \
  --site-email=contact@client.fr \
  --admin-email=admin@client.fr \
  --admin-password=MonMotDePasse123
```

### 5. Activer les modules

```bash
# Blog (articles, categories, tags) — active par defaut pour la plupart des clients
docker compose exec php php bin/console app:module:enable blog

# Optionnel — selon les besoins du client :
docker compose exec php php bin/console app:module:enable services
docker compose exec php php bin/console app:module:enable catalogue
docker compose exec php php bin/console app:module:enable ecommerce    # cree aussi les CGV
docker compose exec php php bin/console app:module:enable events
docker compose exec php php bin/console app:module:enable directory
```

Chaque module active ses routes, cree ses pages legales associees et met a jour les menus.

### 6. Configurer reCAPTCHA (anti-spam)

Le reCAPTCHA v3 protege le formulaire de contact contre les bots. Il est **invisible** pour les visiteurs (pas de case a cocher).

#### Etape 1 — Creer les cles Google (manuelle)

1. Aller sur https://www.google.com/recaptcha/admin
2. Se connecter avec un compte Google
3. Cliquer sur **+** (creer un nouveau site)
4. Remplir :
   - **Label** : nom du client (ex: "Mon Site - client-x")
   - **Type** : reCAPTCHA v3
   - **Domaines** : ajouter le domaine du client (ex: `client-x.fr`) + `localhost` pour le dev
5. Accepter les conditions et valider
6. Copier la **cle du site** (site key) et la **cle secrete** (secret key)

#### Etape 2 — Configurer dans le projet (automatisable)

```bash
docker compose exec php php bin/console app:recaptcha:setup
```

La commande demande les 2 cles et les ecrit dans `.env.local`.

Mode non-interactif (pour agents) :
```bash
docker compose exec php php bin/console app:recaptcha:setup \
  --site-key=6LcXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
  --secret-key=6LcXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Puis vider le cache :
```bash
docker compose exec php php bin/console cache:clear
```

> **Sans reCAPTCHA** : le formulaire de contact reste protege par 3 couches (CSRF + honeypot + rate limiting 3/min). Le reCAPTCHA est recommande en production mais pas obligatoire.

### 7. Personnaliser dans l'admin

Se connecter a http://localhost:8080/admin puis :

1. **Identite du site** (Reglages > Identite) — logo, coordonnees completes, description
2. **Theme et couleurs** (Reglages > Apparence) — choix du theme, couleurs, polices
3. **Navigation** (Reglages > Navigation) — organiser les menus par drag & drop
4. **Contenu** — creer articles, pages, ajouter des medias
5. **SEO** — remplir les champs SEO des pages principales
6. **Guide** — consulter Aide > Guide pour les details

### 8. Resync menus (apres changement de theme)

```bash
docker compose exec php php bin/console app:menu:sync
```

---

## Acces dev

| Service | URL |
|---------|-----|
| Site | http://localhost:8080 |
| Admin | http://localhost:8080/admin |
| Mailpit | http://localhost:8025 |
| MariaDB | localhost:3307 (app/app) |

---

## Toutes les commandes disponibles

| Commande | Role | Description |
|----------|------|-------------|
| `app:client:setup` | Setup initial | Cree site + admin + pages legales + menus (idempotent) |
| `app:module:enable <module>` | Modules | Active un module (blog, services, catalogue, ecommerce, events, directory) |
| `app:module:disable <module>` | Modules | Desactive un module |
| `app:recaptcha:setup` | Securite | Configure les cles reCAPTCHA v3 dans .env.local |
| `app:menu:sync` | Navigation | Resynchronise les menus systeme depuis le theme |
| `app:create-super-admin` | Legacy | Cree un super admin (utiliser `app:client:setup` a la place) |
| `app:init-site` | Legacy | Initialise le site (utiliser `app:client:setup` a la place) |

---

## Architecture git — branches client

### Principe

Chaque client a sa propre branche git creee depuis `master`. Le CMS commun vit sur `develop` / `master`, les personnalisations client (templates custom, CSS, structure de home) vivent sur la branche client.

```
master                          ← CMS stable, reference pour tous les clients
  │
  ├── develop                   ← Dev en cours des features CMS
  │
  ├── client/boulangerie-martin ← Branche client (home custom, CSS, contenu)
  ├── client/garage-dupont      ← Branche client
  └── client/cabinet-avocat     ← Branche client
```

| Element | Ou ca vit | Touche par merge master ? |
|---------|-----------|--------------------------|
| Code CMS (controllers, entities, services) | master | **Oui** — c'est le but |
| Templates custom du client | branche client | **Non** — fichiers differents |
| CSS custom du client | branche client | **Non** — fichiers differents |
| Contenu (articles, pages) | BDD MariaDB | **Non** |
| Images uploadees | `public/uploads/` | **Non** |
| Config client (.env.local) | Fichier local (gitignore) | **Non** |
| Theme, couleurs, polices | BDD (entite Site) | **Non** |

### Workflow : ajouter une feature au CMS

```bash
# 1. Revenir sur develop
git checkout develop

# 2. Coder, tester, commit
# ... ajouter la feature ...
git add ... && git commit -m "feat: description" && git push

# 3. Merger dans master quand c'est stable
git checkout master && git merge develop && git push

# 4. Propager vers la branche client
git checkout client/boulangerie-martin
git merge master
# Resoudre les conflits si besoin (rare)
make update
```

### Workflow : corriger un bug

```bash
# 1. Corriger sur develop, merger dans master
cd ~/projects/blog_web
git checkout develop
# ... fix ...
git add ... && git commit -m "fix: description" && git push
git checkout master && git merge develop && git push

# 2. Propager vers chaque branche client
for branch in $(git branch --list 'client/*'); do
    echo "=== Mise a jour: $branch ==="
    git checkout "$branch" && git merge master && make update
done
```

### Mise a jour en production

```bash
cd /var/www/clients/client-x
git pull origin client/nom-du-client
make deploy    # = scripts/deploy.sh (assets build en mode prod, --no-dev, restart services)
```

### Regles importantes

- **Features CMS** : toujours sur `develop`, jamais directement sur une branche client
- **Personnalisations client** (home custom, CSS, images) : uniquement sur la branche `client/xxx`
- **Ne jamais modifier le core CMS** sur une branche client — sinon merge conflicts garantis
- **Tester d'abord** sur `develop` avant de merger dans `master`
- **Merger `master` dans la branche client** apres chaque release pour garder le CMS a jour
- **Si une migration echoue** : `deploy.sh` rollback automatiquement la derniere migration

### Ce qui conflicte (ou pas)

| Fichier | Conflit probable ? |
|---------|-------------------|
| Templates custom du client (home, hero, CSS) | **Non** — fichiers propres au client |
| `src/Controller/`, `src/Entity/`, `src/Service/` | **Non** — pas touches cote client |
| Templates de base des themes | **Rare** — le client a ses propres fichiers |
| `config/`, `docker/`, `Makefile` | **Non** — partage, pas modifie cote client |
| Un template modifie des deux cotes | **Oui** — seul cas, merge manuel |

### Cas particuliers

**Ajout d'un nouveau module :** apres `git merge master`, activer le module si besoin :
```bash
docker compose exec php php bin/console app:module:enable <module>
```

**Changement de theme :** apres `git merge master`, resync les menus si le theme a change :
```bash
docker compose exec php php bin/console app:menu:sync
```

---

## Fichiers de developpement

Le repo contient des fichiers de documentation technique (specs, audit, roadmap) dans `.claude/docs/`. Ces fichiers sont **utiles pour le developpement** mais ne doivent **jamais** se retrouver chez un client.

**Nettoyage automatique :** `app:client:setup` (etape 5) supprime automatiquement :
- `CLAUDE.md`, `CLAUDE2.md`, `CLAUDE_FULL.md` (specs techniques)
- `PLAN.md`, `DESIGN_THEME.md` (plans de dev)
- `audit_cms_claude_code.md` (audit securite)
- `.claude/docs/` (documentation detaillee)

**Securite supplementaire :** `scripts/deploy.sh` nettoie aussi ces fichiers a chaque deploiement.

> **Migration initiale (une seule fois sur le repo de dev) :** pour deplacer les docs vers `.claude/docs/`, lancer `./scripts/migrate-docs.sh` puis remplacer CLAUDE.md par CLAUDE.md.new.

---

## Notes

- **Pages legales** : editez le contenu dans Admin > Pages (les pages systeme sont pre-remplies avec des sections `[A COMPLETER]`).
- **Menus** : les elements systeme sont editables (renommer, reordonner, masquer) mais pas supprimables. Ajoutez vos propres liens dans Reglages > Navigation.
- **BDD vierge** : `make db` repart de zero (drop + create + migrate). Aucune donnee de test ne se retrouve chez le client.
- **Commandes legacy** : `app:create-super-admin` et `app:init-site` fonctionnent toujours separement si besoin, mais `app:client:setup` les remplace.
- **Verification email** : les utilisateurs inscrits via le formulaire doivent confirmer leur email avant de pouvoir se connecter. Les comptes admin crees via CLI sont exempts.
- **Securite contact** : 4 couches de protection (CSRF + honeypot + rate limiting + reCAPTCHA v3 optionnel).

---

## Guide pour Claude Code / agents

Ce projet est prevu pour etre installe et personnalise via Claude Code. Voici le workflow type :

1. **L'utilisateur fournit** : la fiche de reference client (voir `client_reference_template.md`)
2. **L'agent cree la branche** `client/nom-du-client` depuis `master`
3. **L'agent execute** le setup : `.env.local`, `make up`, `make db`, `make assets`, `app:client:setup`
4. **L'agent active les modules** selon la fiche
5. **L'utilisateur fournit** les cles reCAPTCHA (creees manuellement sur Google)
6. **L'agent configure** le reCAPTCHA via `app:recaptcha:setup --site-key=... --secret-key=...`
7. **L'agent personnalise** le site dans l'admin (theme, couleurs, contenu) via le navigateur
8. **L'agent customise** les templates et le CSS sur la branche client (home, hero, sections)
9. **L'agent commit** les personnalisations sur la branche `client/nom-du-client`
10. **L'utilisateur valide** le rendu et le contenu
11. **Push en prod** quand c'est valide

Les seules etapes manuelles sont :
- Creer les cles reCAPTCHA sur Google (necessite un compte Google + navigateur)
- Creer le compte Brevo et recuperer les identifiants SMTP
- Valider le contenu final

> **Regle importante pour l'agent :** ne jamais modifier le core CMS (controllers, entities, services) sur une branche client. Les personnalisations client se limitent aux templates, CSS, images et contenu.
