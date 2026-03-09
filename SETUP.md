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

## 8. Accéder au site

| Service | URL |
|---------|-----|
| Site | http://localhost:8080 |
| Admin | http://localhost:8080/admin |
| Mailpit | http://localhost:8025 |

Se connecter à `/admin` avec le compte super admin pour personnaliser (logo, couleurs, menus, contenu).
