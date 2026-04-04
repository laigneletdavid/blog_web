# Reference deploiement BlogWeb — OVH mutualise

## Architecture Git

```
main                    ← CMS commun, jamais en prod
  ├── bw_front          ← blogweb.comwebsolutions.fr
  ├── bw_client2        ← futur client
  └── bw_client3        ← futur client
```

- **main** = tronc commun, features CMS, jamais deploye
- **bw_*** = branches clients, deployees en prod
- Les clients ne modifient JAMAIS les fichiers de main (templates themes, controllers, entities)
- Les customisations client vont dans `templates/client/` (override automatique)
- Quand main evolue : `git checkout bw_xxx && git merge main` (jamais rebase, jamais l'inverse)

---

## Nouveau client — Circuit complet

### 1. En local (dev)

```bash
# Creer la branche client
git checkout main && git pull
git checkout -b bw_nom_client

# Configurer la BDD locale
# Dans .env.local, changer DATABASE_URL pour pointer vers bw_nom_client
DATABASE_URL="mysql://app:app@db:3306/bw_nom_client?serverVersion=mariadb-11.0.0&charset=utf8mb4"

# Creer la BDD + tables
docker compose exec php php bin/console doctrine:database:create
docker compose exec php php bin/console doctrine:migrations:migrate --no-interaction

# Setup du site (interactif)
docker compose exec php php bin/console app:client:setup

# Activer les modules
docker compose exec php php bin/console app:module:enable blog
# ... autres modules selon le client

# Build assets
make assets

# Personnaliser dans l'admin (http://localhost:8080/admin)
# - Theme, couleurs, polices
# - Logo, favicon (via Media)
# - Contenu, pages, articles
# - Navigation

# Templates custom (si besoin)
# Copier le template du theme dans templates/client/ et modifier
# Ex: cp templates/themes/vitrine/_header.html.twig templates/client/_header.html.twig
git add -f templates/client/  # Force car gitignore sur main
```

### 2. Preparer le deploy

```bash
# Dump de la BDD
make db-dump
# → Cree scripts/bw_nom_client_dump.sql automatiquement

# Ajouter le workflow CI/CD (copier depuis bw_front et adapter le trigger)
mkdir -p .github/workflows
# Editer .github/workflows/deploy.yml : branches: [bw_nom_client]

# Commit + push
git add -f scripts/bw_nom_client_dump.sql .github/workflows/deploy.yml templates/client/
git commit -m "Feat: bw_nom_client - setup initial"
git push -u origin bw_nom_client
```

### 3. Sur OVH (premier deploy)

```bash
# Connexion SSH
ssh user@ssh.clusterXXX.hosting.ovh.net

# Clone
git clone -b bw_nom_client https://github.com/laigneletdavid/blog_web.git .

# Deploy complet (tout-en-un)
chmod +x scripts/deploy-ovh.sh
./scripts/deploy-ovh.sh --init
```

Le `--init` demande interactivement :
- Host BDD, port, user, password, nom BDD → genere .env.local
- MAILER_DSN Brevo
- Chemin du dump SQL → **donner `scripts/bw_nom_client_dump.sql`**
- Teste la connexion BDD avant de continuer
- Lance le deploy : composer + nvm/node + build assets + cache + import dump

**C'est tout. Le site est en ligne.**

### 4. Mises a jour

Quand main evolue (nouvelle feature CMS) :

```bash
# En local
git checkout bw_nom_client
git merge main
git push origin bw_nom_client

# Sur OVH
ssh user@host
./scripts/deploy-ovh.sh
# → pull + composer + assets + cache + migrations
```

---

## Commandes du script deploy-ovh.sh

| Commande | Usage |
|----------|-------|
| `./scripts/deploy-ovh.sh --init` | Premier deploy : genere .env.local + deploy + import dump |
| `./scripts/deploy-ovh.sh --import fichier.sql` | Import dump SQL (conversion MariaDB→MySQL auto) |
| `./scripts/deploy-ovh.sh` | Mise a jour : pull + build + cache + migrations |

---

## Infos necessaires par client

A collecter avant le deploy :

| Info | Ou la trouver | Utilise pour |
|------|---------------|--------------|
| Host BDD | OVH > CloudDB > Infos connexion | DATABASE_URL |
| Port BDD | OVH > CloudDB > Infos connexion | DATABASE_URL |
| User BDD | OVH > CloudDB > Utilisateurs | DATABASE_URL |
| Password BDD | OVH > CloudDB > Utilisateurs | DATABASE_URL |
| Nom BDD | OVH > CloudDB > Bases de donnees | DATABASE_URL |
| MAILER_DSN | Brevo > SMTP & API | Emails transactionnels |
| SSH host | OVH > Hebergement > FTP-SSH | Connexion SSH |
| SSH user | OVH > Hebergement > FTP-SSH | Connexion SSH |
| SSH password | OVH > Hebergement > FTP-SSH | Connexion SSH |
| Domaine | Client | DNS + multisite OVH |

---

## Override templates client

Priorite de chargement Twig :
```
1. templates/client/     ← Override client (si existe)
2. templates/themes/X/   ← Template du theme
3. templates/default/    ← Fallback
```

Templates overridables :
- `_header.html.twig` — Header
- `_footer.html.twig` — Footer
- `home.html.twig` — Page d'accueil
- `contact.html.twig` — Page contact
- `blog.html.twig` — Liste articles

Pour creer un override :
```bash
# Copier le template du theme actuel
cp templates/themes/vitrine/_header.html.twig templates/client/_header.html.twig
# Modifier templates/client/_header.html.twig
# Force-add (gitignore sur main)
git add -f templates/client/_header.html.twig
```

---

## Conversion MariaDB → MySQL (automatique)

Le script `--import` corrige automatiquement :
- `utf8mb4_uca1400_ai_ci` → `utf8mb4_unicode_ci`
- `/*M!999999\- enable the sandbox mode */` → supprime
- `DEFAULT '["..."]' CHECK (json_valid(...))` → supprime

---

## Checklist pre-deploy

- [ ] BDD locale dumpee (`make db-dump`)
- [ ] Dump SQL dans `scripts/`
- [ ] .env.local local pointe vers la bonne BDD
- [ ] Templates custom dans `templates/client/` (si besoin)
- [ ] Workflow CI/CD adapte (trigger sur la bonne branche)
- [ ] BDD OVH creee (CloudDB)
- [ ] IP hebergement autorisee sur CloudDB
- [ ] Domaine configure sur OVH (multisite)
- [ ] Credentials OVH (SSH + BDD + Brevo) notes

---

## Problemes connus et solutions

| Probleme | Cause | Solution |
|----------|-------|----------|
| `PHP 4.4.9` en SSH | .ovhconfig manquant | Deja dans le repo, reconnexion SSH |
| `DebugBundle not found` | APP_ENV pas prod | Script exporte APP_ENV=prod auto |
| `enabled_modules can't have default` | MySQL 8 strict | --import corrige auto, --init skip migrations si dump |
| `utf8mb4_uca1400_ai_ci` | MariaDB vs MySQL | --import convertit auto |
| `No such file or directory` BDD | .env.prod ecrase DATABASE_URL | .env.prod supprime du repo |
| `MESSENGER_TRANSPORT_DSN` corrompu | Erreur manuelle | --init genere un .env.local propre |
| Conflits au merge | Fichiers modifies des 2 cotes | Override dans templates/client/, merge sans conflit |
