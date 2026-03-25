# Installation d'un nouveau site client

## Prerequis

- Docker + Docker Compose
- Git

## Process rapide (5 etapes)

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

La commande est **idempotente** : si le site ou l'admin existent deja, ces etapes sont ignorees.

Mode non-interactif (pour scripts) :
```bash
docker compose exec php php bin/console app:client:setup \
  --site-name="Mon Site" \
  --site-email=contact@client.fr \
  --admin-email=admin@client.fr \
  --admin-password=MonMotDePasse123
```

### 5. Activer les modules

```bash
# Blog (articles, categories, tags)
docker compose exec php php bin/console app:module:enable blog

# Optionnel — selon les besoins du client :
docker compose exec php php bin/console app:module:enable services
docker compose exec php php bin/console app:module:enable catalogue
docker compose exec php php bin/console app:module:enable ecommerce    # cree aussi les CGV
docker compose exec php php bin/console app:module:enable events
docker compose exec php php bin/console app:module:enable directory
```

Chaque module active ses routes, cree ses pages legales associees et met a jour les menus.

### 6. Personnaliser dans l'admin

Se connecter a http://localhost:8080/admin puis :

1. **Identite du site** (Reglages > Identite) — logo, coordonnees completes, description
2. **Theme et couleurs** (Reglages > Apparence) — choix du theme, couleurs, polices
3. **Navigation** (Reglages > Navigation) — organiser les menus par drag & drop
4. **Contenu** — creer articles, pages, ajouter des medias
5. **SEO** — remplir les champs SEO des pages principales
6. **Guide** — consulter Aide > Guide pour les details

### 7. Resync menus (apres changement de theme)

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

## Notes

- **Pages legales** : editez le contenu dans Admin > Pages (les pages systeme sont pre-remplies avec des sections `[A COMPLETER]`).
- **Menus** : les elements systeme sont editables (renommer, reordonner, masquer) mais pas supprimables. Ajoutez vos propres liens dans Reglages > Navigation.
- **BDD vierge** : `make db` repart de zero (drop + create + migrate). Aucune donnee de test ne se retrouve chez le client.
- **Commandes legacy** : `app:create-super-admin` et `app:init-site` fonctionnent toujours separement si besoin, mais `app:client:setup` les remplace.
