# Installation d'un nouveau site

## Prérequis

- Docker + Docker Compose
- Git

## 1. Cloner le repo

```bash
git clone git@github.com:laigneletdavid/blog_web.git /var/www/clients/client-x
cd /var/www/clients/client-x
```

## 2. Configurer l'environnement

```bash
cp .env.local.example .env.local
```

Editer `.env.local` :
- `APP_SECRET` : générer une clé unique (`openssl rand -hex 32`)
- `DATABASE_URL` : adapter le nom de la BDD pour ce client
- `MAILER_DSN` : clé API Brevo

## 3. Lancer Docker

```bash
make up
```

Vérifier que tout tourne : `docker compose ps`

## 4. Créer la base de données

```bash
make db
```

## 5. Builder les assets

```bash
make assets
```

## 6. Créer le super admin

```bash
docker compose exec php php bin/console app:create-super-admin
```

> Email, mot de passe (min 12 car.), nom, prénom.

## 7. Configurer le site

```bash
docker compose exec php php bin/console app:init-site
```

> Nom du site, titre, email de contact.
> Crée automatiquement les pages légales (mentions légales, politique de confidentialité) et les menus de navigation système.

## 8. Activer les modules

```bash
# Active le blog (articles, catégories)
docker compose exec php php bin/console app:module:enable blog

# Optionnel — selon les besoins du client :
docker compose exec php php bin/console app:module:enable services
docker compose exec php php bin/console app:module:enable catalogue
docker compose exec php php bin/console app:module:enable ecommerce    # crée aussi les CGV
docker compose exec php php bin/console app:module:enable events
docker compose exec php php bin/console app:module:enable directory
```

> Chaque module active ses routes, crée ses pages légales associées et met à jour les menus.

## 9. Resync menus (après changement de thème)

```bash
docker compose exec php php bin/console app:menu:sync
```

## 10. Accéder au site

| Service | URL |
|---------|-----|
| Site | http://localhost:8080 |
| Admin | http://localhost:8080/admin |
| Mailpit | http://localhost:8025 |

Se connecter à `/admin` avec le compte super admin pour personnaliser (logo, couleurs, thème, contenu).

> **Pages légales** : éditer le contenu dans Admin > Pages (les pages système sont pré-remplies avec des sections `[À COMPLÉTER]`).
> **Menus** : les éléments système sont éditables (renommer, réordonner, masquer) mais pas supprimables. Ajoutez vos propres liens dans Admin > Navigation.
