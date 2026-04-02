# Installation d'un nouveau site client

## Prerequis

- Docker + Docker Compose
- Git
- Un compte Google (pour reCAPTCHA)
- Un compte Brevo (pour les emails transactionnels)

## Process rapide

```bash
# 1. Creer la branche client depuis main
cd ~/projects/blog_web
git checkout main
git checkout -b bw_nom-du-client

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

Chaque client a sa propre branche git, creee depuis `main`. Cela permet de personnaliser librement les templates, le CSS et la structure tout en recevant les mises a jour du CMS via `git rebase main`.

```bash
cd ~/projects/blog_web
git checkout main
git pull origin main
git checkout -b bw_nom-du-client
```

Convention de nommage : `bw_nom-du-client` (ex: `bw_boulangerie-martin`, `bw_garage-dupont`).

> **Pour le deploiement en production**, cloner le repo et checkout la branche client :
> ```bash
> git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
> cd /var/www/clients/client-x
> git checkout bw_nom-du-client
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
docker compose exec php php bin/console app:module:enable faq
docker compose exec php php bin/console app:module:enable portfolio
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

### 7. Injecter les images d'identite

> **Utilisateur** : fournir les fichiers. **Agent** : les injecter dans le projet et la BDD.

Les images du site se repartissent en deux categories :

#### Images injectees par l'agent (identite du site)

Ces images sont **techniques** — elles doivent etre en place avant la personnalisation. L'utilisateur les fournit, l'agent les injecte directement en BDD et dans le filesystem.

| Image | Format attendu | Destination | Champ Site |
|-------|---------------|-------------|------------|
| **Logo** | PNG transparent ou JPG, horizontal ou carre, ~150px de haut | `public/documents/medias/` + Media en BDD | `logo` |
| **Favicon** | PNG carre, 32x32 ou 64x64 px | `public/documents/medias/` + Media en BDD | `favicon` |
| **Image Open Graph** | JPG ou PNG, 1200x630 px (apercu reseaux sociaux) | `public/documents/medias/` + Media en BDD | `ogImage` |
| Apple-touch-icon (optionnel) | PNG carre, 180x180 px | `public/images/apple-touch-icon.png` | — |

**Ce que l'agent fait :**

1. Copie les fichiers dans `public/documents/medias/`
2. Cree les entrees `Media` en BDD pour chaque fichier
3. Associe au `Site` les champs `logo`, `favicon` et `ogImage`
4. Remplace les fallbacks statiques dans `public/images/` si fournis (favicon-16x16, favicon-32x32, apple-touch-icon)

> **Verif rapide :** recharger http://localhost:8080 — le logo doit apparaitre dans le header et le favicon dans l'onglet du navigateur.

#### Images importees via l'admin (contenu visuel)

Ces images sont **editoriales** — elles relevent de la personnalisation du site et se gerent dans Admin > Medias puis se selectionnent dans les formulaires.

| Image | Ou la selectionner | Role |
|-------|-------------------|------|
| **Image hero** | Reglages > Apparence > Images du theme | Grande image d'accueil (bandeau principal). Fallback OG si pas d'image OG dediee. |
| **Image a propos** | Reglages > Apparence > Images du theme | Illustration section "A propos" sur la home |
| **Galerie** | Reglages > Apparence > Images du theme | Slot `gallery` — carousel ou grille sur la home |
| **Logos clients** | Reglages > Apparence > Images du theme | Slot `logo` — bandeau de logos partenaires/clients |
| **Temoignages** | Reglages > Apparence > Images du theme | Slot `testimonial` — photos temoignages |
| **Images articles/pages** | Contenu > Articles / Pages | Image a la une (utilisee aussi comme OG de l'article) |

> **Fallback OG :** si l'image Open Graph n'est pas definie, le systeme utilise automatiquement : `ogImage > heroImage > logo`.

### 8. Personnaliser dans l'admin

> **Utilisateur** : valide le rendu. **Agent** : execute les modifications dans l'admin.

Se connecter a http://localhost:8080/admin puis :

1. **Identite du site** (Reglages > Identite) — coordonnees completes, description, SEO par defaut
2. **Theme et couleurs** (Reglages > Apparence) — choix du theme, couleurs, polices
3. **Images du theme** (Reglages > Apparence) — hero, a propos, galerie, logos, temoignages (via admin Medias)
4. **Navigation** (Reglages > Navigation) — organiser les menus par drag & drop
5. **Contenu** — creer articles, pages, ajouter des medias
6. **SEO** — remplir les champs SEO des pages principales
7. **Guide** — consulter Aide > Guide pour les details

### 9. Resync menus (apres changement de theme)

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
| `app:module:enable <module>` | Modules | Active un module (blog, services, catalogue, ecommerce, events, directory, faq, portfolio) |
| `app:module:disable <module>` | Modules | Desactive un module |
| `app:recaptcha:setup` | Securite | Configure les cles reCAPTCHA v3 dans .env.local |
| `app:menu:sync` | Navigation | Resynchronise les menus systeme depuis le theme |
| `app:legal-pages:update` | Contenu | Regenere les pages legales (mentions, confidentialite, CGV) |
| `app:media:regenerate-sizes` | Medias | Regenere les 3 tailles WebP (480, 800, 1200px) des medias existants |
| `app:create-super-admin` | Standalone | Cree un super admin (inclus dans `app:client:setup`) |
| `app:init-site` | Standalone | Initialise le site (inclus dans `app:client:setup`) |

---

## Deploiement en production

Deux modes de deploiement selon l'hebergement :

| Mode | Hebergement | Comment |
|------|-------------|---------|
| **CI/CD** (recommande) | OVH mutualise, tout hebergement SSH | Push sur `main` → deploy automatique via GitHub Actions |
| **Docker** | VPS, cloud, dedie | `make deploy` avec docker-compose.prod.yml |
| **Manuel** | OVH mutualise (backup) | `scripts/deploy-ovh.sh` en SSH |

---

### Mode A — CI/CD GitHub Actions (recommande pour OVH mutualise)

Le workflow `.github/workflows/deploy.yml` fait tout automatiquement :
build des assets dans le CI (Node 20, pas de restrictions OVH), deploy via SSH/rsync.

#### Setup (une seule fois)

1. **Configurer les secrets GitHub** (Settings > Secrets and variables > Actions) :

| Secret | Valeur |
|--------|--------|
| `OVH_SSH_HOST` | Hostname SSH OVH (ex: `ssh.cluster0XX.hosting.ovh.net`) |
| `OVH_SSH_USER` | Login SSH OVH |
| `OVH_SSH_KEY` | Cle privee SSH (contenu complet, inclure `-----BEGIN...`) |
| `OVH_SSH_PORT` | Port SSH (defaut: 22) |
| `OVH_DEPLOY_PATH` | Chemin du site (ex: `/home/loginovh/www`) |

2. **Sur OVH** — preparer le `.env.local` (une seule fois) :

```bash
ssh user@host
cd /chemin/du/site
cp .env.local.example .env.local
# Editer : APP_SECRET (generer avec: php -r "echo bin2hex(random_bytes(16));")
#          DATABASE_URL (credentials phpMyAdmin OVH)
#          MAILER_DSN (Brevo)
```

3. **Creer la BDD** via phpMyAdmin OVH et importer le dump initial.

#### Deployer

```bash
git push origin main   # C'est tout. Le CI build + deploy automatiquement.
```

Le workflow : checkout → check conflits Git → composer install --no-dev → npm ci + encore production → rsync vers OVH → cache:clear + migrations.

---

### Mode B — Docker (VPS / cloud / dedie)

```bash
# Premier deploiement
git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
git checkout bw_nom-du-client
cp .env.local.example .env.local
# Editer : APP_ENV=prod, APP_SECRET, DATABASE_URL, MAILER_DSN

docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
docker compose exec php php bin/console doctrine:migrations:migrate --no-interaction
docker compose exec php php bin/console cache:clear --env=prod
```

Le docker-compose prod (`docker-compose.prod.yml`) active :
- PHP target `prod` (opcache, APCu)
- Nginx sur port **80**
- BDD port ferme, healthchecks, logs limites
- Mailpit desactive (emails via Brevo)

---

### Mode C — Manuel OVH (backup / urgence)

Si le CI est down ou pour un hotfix rapide, utiliser `scripts/deploy-ovh.sh` en SSH :

```bash
ssh user@host
cd /chemin/du/site
./scripts/deploy-ovh.sh
```

Ce script gere tout : check PHP, pull, composer, nvm/node, patch sync-rpc, build assets, cache, migrations.

---

### Commandes Make

| Commande | Contexte | Ce qu'elle fait |
|----------|----------|-----------------|
| `make update` | **Dev** | pull + composer + migrate + assets dev + cache:clear |
| `make deploy` | **Prod Docker** | `scripts/deploy.sh` : pull + composer --no-dev + migrate (rollback) + assets + restart |
| `make backup` | **Dev/Prod** | Dump compresse de la BDD |
| `make db-dump` | **Dev** | Dump BDD via docker compose (mariadb-dump) |
| `make restore FILE=...` | **Prod** | Restaure un dump compresse |

---

## Architecture git — branches client

### Principe

Chaque client a sa propre branche git creee depuis `main`. Le CMS commun vit sur `main`, les personnalisations client (templates custom, CSS, structure de home) vivent sur la branche client. Quand une nouvelle feature arrive sur `main`, chaque branche client est **rebasee** sur `main`.

```
main                          ← CMS stable, reference pour tous les clients
  │
  ├── bw_front                  ← Site vitrine BlogWeb
  ├── bw_boulangerie-martin     ← Branche client (home custom, CSS, contenu)
  ├── bw_garage-dupont          ← Branche client
  └── bw_cabinet-avocat         ← Branche client
```

| Element | Ou ca vit | Touche par rebase main ? |
|---------|-----------|--------------------------|
| Code CMS (controllers, entities, services) | main | **Oui** — c'est le but |
| Templates custom du client | branche client | **Non** — fichiers differents |
| CSS custom du client | branche client | **Non** — fichiers differents |
| Contenu (articles, pages) | BDD MariaDB | **Non** |
| Images uploadees | `public/uploads/` | **Non** |
| Config client (.env.local) | Fichier local (gitignore) | **Non** |
| Theme, couleurs, polices | BDD (entite Site) | **Non** |

### Workflow : ajouter une feature au CMS

```bash
# 1. Developper sur main (ou une branche feature mergee dans main)
git checkout main
# ... ajouter la feature ...
git add ... && git commit -m "feat: description" && git push

# 2. Rebaser chaque branche client sur le nouveau main
git checkout bw_boulangerie-martin
git rebase main
# Resoudre les conflits si besoin (rare)
make update
```

### Workflow : corriger un bug

```bash
# 1. Corriger sur main
cd ~/projects/blog_web
git checkout main
# ... fix ...
git add ... && git commit -m "fix: description" && git push

# 2. Rebaser chaque branche client
for branch in $(git branch --list 'bw_*'); do
    echo "=== Mise a jour: $branch ==="
    git checkout "$branch" && git rebase main && make update
done
```

### Mise a jour en production

```bash
cd /var/www/clients/client-x
git pull origin bw_nom-du-client
make deploy    # = scripts/deploy.sh (assets build en mode prod, --no-dev, restart services)
```

### Regles importantes

- **Features CMS** : toujours sur `main`, jamais directement sur une branche client
- **Personnalisations client** (home custom, CSS, images) : uniquement sur la branche `bw_xxx`
- **Ne jamais modifier le core CMS** sur une branche client — sinon conflits au rebase garantis
- **Rebaser la branche client sur `main`** apres chaque release pour garder le CMS a jour
- **Si une migration echoue** : `deploy.sh` rollback automatiquement la derniere migration

### Ce qui conflicte (ou pas)

| Fichier | Conflit probable ? |
|---------|-------------------|
| Templates custom du client (home, hero, CSS) | **Non** — fichiers propres au client |
| `src/Controller/`, `src/Entity/`, `src/Service/` | **Non** — pas touches cote client |
| Templates de base des themes | **Rare** — le client a ses propres fichiers |
| `config/`, `docker/`, `Makefile` | **Non** — partage, pas modifie cote client |
| Un template modifie des deux cotes | **Oui** — seul cas, resolution manuelle au rebase |

### Cas particuliers

**Ajout d'un nouveau module :** apres `git rebase main`, activer le module si besoin :
```bash
docker compose exec php php bin/console app:module:enable <module>
```

**Changement de theme :** apres `git rebase main`, resync les menus si le theme a change :
```bash
docker compose exec php php bin/console app:menu:sync
```

---

## Fichiers de developpement

Le repo contient des fichiers de documentation technique (specs, audit, roadmap) dans `.claude/docs/`. Ces fichiers sont **utiles pour le developpement** mais ne doivent **jamais** se retrouver chez un client.

**Nettoyage automatique :** `app:client:setup` (etape 5) supprime automatiquement :
- `CLAUDE.md`, `CLAUDE2.md`, `CLAUDE3.md`, `CLAUDE_FULL.md` (conventions et specs techniques)
- `PLAN.md`, `DESIGN_THEME.md` (plans de dev)
- `audit_cms_claude_code.md` (audit securite)
- `.claude/docs/` (documentation detaillee)

**Securite supplementaire :** `scripts/deploy.sh` nettoie aussi ces fichiers a chaque deploiement.

> **Migration initiale (une seule fois sur le repo de dev) :** pour deplacer les docs vers `.claude/docs/`, lancer `./scripts/migrate-docs.sh` puis remplacer CLAUDE.md par CLAUDE.md.new.

---

## Hook pre-commit (marqueurs de conflit)

Le repo inclut un hook `.githooks/pre-commit` qui bloque les commits contenant des marqueurs de conflit Git (`<<<<<<<`, `=======`, `>>>>>>>`). A activer une fois par clone :

```bash
git config core.hooksPath .githooks
```

---

## Notes

- **Pages legales** : editez le contenu dans Admin > Pages (les pages systeme sont pre-remplies avec des sections `[A COMPLETER]`).
- **Menus** : les elements systeme sont editables (renommer, reordonner, masquer) mais pas supprimables. Ajoutez vos propres liens dans Reglages > Navigation.
- **BDD vierge** : `make db` repart de zero (drop + create + migrate). Aucune donnee de test ne se retrouve chez le client.
- **Commandes standalone** : `app:create-super-admin` et `app:init-site` fonctionnent separement si besoin, mais `app:client:setup` les englobe.
- **Verification email** : les utilisateurs inscrits via le formulaire doivent confirmer leur email avant de pouvoir se connecter. Les comptes admin crees via CLI sont exempts.
- **Securite contact** : 4 couches de protection (CSRF + honeypot + rate limiting + reCAPTCHA v3 optionnel).

---

## Guide pour Claude Code / agents

Ce projet est prevu pour etre installe et personnalise via Claude Code. Voici le workflow type :

| Etape | Qui | Action |
|-------|-----|--------|
| 1 | **Utilisateur** | Fournit la fiche de reference client (`client_reference_template.md`) |
| 2 | **Agent** | Cree la branche `bw_nom-du-client` depuis `main` |
| 3 | **Agent** | Execute le setup : `.env.local`, `make up`, `make db`, `make assets`, `app:client:setup` |
| 4 | **Agent** | Active les modules selon la fiche |
| 5 | **Utilisateur** | Fournit les cles reCAPTCHA (creees sur Google) |
| 6 | **Agent** | Configure le reCAPTCHA via `app:recaptcha:setup --site-key=... --secret-key=...` |
| 7 | **Utilisateur** | Fournit les images d'identite : logo (PNG/JPG), favicon (PNG 32x32/64x64), image OG (JPG/PNG 1200x630) |
| 8 | **Agent** | Injecte logo + favicon + OG dans `public/documents/medias/`, cree les Media en BDD, associe au Site (`logo`, `favicon`, `ogImage`) |
| 9 | **Agent** | Personnalise le site dans l'admin (theme, couleurs, SEO par defaut) |
| 10 | **Utilisateur** | Fournit les images de contenu : hero, a propos, galerie, logos clients, temoignages |
| 11 | **Agent** | Importe les images de contenu via Admin > Medias, les associe dans Apparence > Images du theme |
| 12 | **Agent** | Customise les templates et le CSS sur la branche client |
| 13 | **Agent** | Commit les personnalisations sur la branche `bw_nom-du-client` |
| 14 | **Utilisateur** | Valide le rendu et le contenu |
| 15 | **Ensemble** | Push en prod quand c'est valide |

Les seules etapes manuelles (utilisateur) sont :
- Fournir la fiche client
- Creer les cles reCAPTCHA sur Google (necessite un compte Google)
- Fournir les images d'identite (logo, favicon, OG) — injectees par l'agent
- Fournir les images de contenu (hero, a propos, galerie...) — importees via l'admin par l'agent
- Creer le compte Brevo et recuperer les identifiants SMTP
- Valider le contenu final

> **Distinction importante :**
> - **Images d'identite** (logo, favicon, OG) → l'agent les injecte directement dans le filesystem + BDD (etape 8)
> - **Images de contenu** (hero, a propos, galerie, temoignages, logos clients) → l'agent les importe via Admin > Medias puis les selectionne dans les formulaires (etape 11)

> **Regle importante pour l'agent :** ne jamais modifier le core CMS (controllers, entities, services) sur une branche client. Les personnalisations client se limitent aux templates, CSS, images et contenu.
