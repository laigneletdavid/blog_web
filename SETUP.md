# Installation d'un nouveau site client

## Prerequis

- Docker + Docker Compose
- Git
- Un compte Google (pour reCAPTCHA)
- Un compte Brevo (pour les emails transactionnels)

## Process rapide

```bash
# 1. Cloner
git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x

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

# 7. Vider le cache
docker compose exec php php bin/console cache:clear
```

Le site est pret sur http://localhost:8080/admin

---

## Detail des etapes

### 1. Cloner le repo

```bash
git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
```

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

## Mises a jour

### Principe

Le code du CMS est partage via git. Chaque site client est un clone du meme repo. Les mises a jour se font par `git pull` — les donnees client (BDD, uploads, .env.local) ne sont jamais touchees.

```
blog_web/ (GitHub)              ← Repo source
    │
    ├── clone → site-david/     ← Ton site test
    ├── clone → client-x/       ← Client
    └── clone → client-y/       ← Client
```

| Element | Stockage | Touche par git pull ? |
|---------|----------|---------------------|
| Code PHP, templates, JS, CSS | Fichiers (git) | **Oui** — c'est le but |
| Contenu (articles, pages) | BDD MariaDB | **Non** |
| Images uploadees | `public/uploads/` | **Non** |
| Config client (.env.local) | Fichier local | **Non** |
| Theme, couleurs, polices | BDD (entite Site) | **Non** |
| Menus personnalises | BDD (entite Menu) | **Non** |

### Workflow : corriger un bug ou ajouter une feature

```bash
# 1. Corriger dans le repo source
cd ~/projects/blog_web
# ... corriger le bug / ajouter la feature ...
git add ... && git commit -m "fix: description du bug" && git push

# 2. Mettre a jour un site client
cd /var/www/clients/client-x
make update
```

`make update` fait tout automatiquement :
1. `git pull` — recupere le nouveau code
2. `composer install` — met a jour les dependances PHP si besoin
3. `doctrine:migrations:migrate` — applique les nouvelles migrations BDD
4. `npm install + npm run dev` — rebuild les assets CSS/JS
5. `cache:clear` — vide le cache Symfony

### Mettre a jour tous les clients d'un coup

```bash
for client in /var/www/clients/*/; do
    echo "=== Mise a jour: $client ==="
    cd "$client" && make update
done
```

### Mise a jour en production

```bash
cd /var/www/clients/client-x
make deploy    # = scripts/deploy.sh (assets build en mode prod, --no-dev, restart services)
```

### Regles importantes

- **Toujours travailler dans `blog_web`** pour les modifications du CMS, jamais directement dans un clone client
- **Ne jamais modifier le code manuellement** dans un clone client (sinon git pull echouera en conflit)
- **Toute personnalisation client** passe par la BDD (admin EasyAdmin) ou `.env.local`, jamais par le code
- **Tester d'abord** sur `site-david` avant de deployer chez les vrais clients
- **Si une migration echoue** : `deploy.sh` rollback automatiquement la derniere migration

### Cas particuliers

**Ajout d'un nouveau module :** apres `make update`, activer le module si besoin :
```bash
docker compose exec php php bin/console app:module:enable <module>
```

**Changement de theme :** apres `make update`, resync les menus si le theme a change :
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

1. **L'utilisateur fournit** : nom du client, email, domaine, modules souhaites
2. **L'agent execute** les etapes 1 a 6 ci-dessus (tout est en CLI)
3. **L'utilisateur fournit** les cles reCAPTCHA (creees manuellement sur Google)
4. **L'agent configure** le reCAPTCHA via `app:recaptcha:setup --site-key=... --secret-key=...`
5. **L'agent personnalise** le site dans l'admin (theme, couleurs, contenu) via le navigateur
6. **L'utilisateur valide** le rendu et le contenu

Les seules etapes manuelles sont :
- Creer les cles reCAPTCHA sur Google (necessite un compte Google + navigateur)
- Creer le compte Brevo et recuperer les identifiants SMTP
- Valider le contenu final
