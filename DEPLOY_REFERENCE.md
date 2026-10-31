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

### 2 bis. Fabriquer le dump de deploiement (avant le push)

```bash
./scripts/make-deploy-dump.sh
git add -f scripts/bw_nom_client_dump.sql
git commit -m "chore: dump de deploiement" && git push
```

Le depot etant **public**, ce dump est construit pour pouvoir y figurer : il
emporte la structure complete, le contenu editorial et les numeros de migration
deja appliques, mais **aucun compte, aucune empreinte de mot de passe, aucun
message de contact, aucun abonne, aucune donnee de navigation**. Le script
refuse d'ecrire le fichier s'il y detecte l'un de ces elements.

Consequence : **le compte d'administration n'est pas dans le dump**. Il se cree
sur le serveur, une fois l'import passe :

```bash
php bin/console app:create-super-admin --email=... --password=...
```

Ne jamais livrer un `mysqldump` brut : il contient les empreintes de mots de
passe, et sur un depot public une empreinte faible tombe en quelques secondes.

### 3. Sur OVH (premier deploy)

```bash
# Connexion SSH : par ftp.clusterXXX (l'alias ssh.clusterXXX affiche par
# l'espace client ne repond plus sur cluster100). Un seul essai de mot de
# passe : apres 3 echecs, OVH ignore l'IP un moment.
ssh user@ftp.clusterXXX.hosting.ovh.net

# Clone
git clone -b bw_nom_client https://github.com/laigneletdavid/blog_web.git .

# Deploy complet (tout-en-un)
./scripts/deploy-ovh.sh --init
```

> Le `chmod +x` n'est plus necessaire : les scripts sont executables dans le
> depot. En faire un rendrait le `git pull` suivant impossible, git voyant le
> changement de mode comme une modification locale.

Le `--init` demande interactivement :
- Host BDD, port, user, password, nom BDD → genere .env.local
- MAILER_DSN Brevo
- Chemin du dump SQL → **donner `scripts/bw_nom_client_dump.sql`**
  (les deploys suivants le trouvent seuls dans `scripts/`)
- Teste la connexion BDD avant de continuer
- Lance le deploy : composer + nvm/node + build assets + cache + import dump

**Le site est en ligne.** Reste a le declarer a Google (section 3 bis).

### 3 bis. Apres la mise en ligne : Google Search Console

A faire des que le domaine definitif repond, pas sur un sous-domaine de recette.
Google ne garde que 16 mois d'historique et ne compte qu'a partir de la declaration.

1. https://search.google.com/search-console → « Ajouter une propriete » → type
   **Domaine** (`nom-client.fr`, sans `www` ni `https://`). Elle couvre www et
   non-www, http et https.
2. Google donne un enregistrement `google-site-verification=...`. Dans l'espace
   client OVH : Noms de domaine → le domaine → Zone DNS → Ajouter une entree →
   **TXT**, **sous-domaine vide**, valeur collee telle quelle. Ne pas toucher a
   l'entree SPF (`v=spf1 ...`) existante, on ajoute a cote.
3. Verifier que l'entree est publiee a la racine, puis « Valider » :
   ```bash
   nslookup -type=TXT nom-client.fr dns111.ovh.net
   ```
   Piege rencontre sur bw_mainguy : TXT saisi sous `www` → Google refuse.
4. Menu Sitemaps → envoyer `https://www.nom-client.fr/sitemap.xml`. « Impossible
   de recuperer » juste apres l'envoi est normal sur une propriete neuve tant
   que « Derniere lecture » est vide : Google passe sous quelques jours.
5. Inspection d'URL sur la home → « Demander l'indexation ».

Plus de champ « code de verification » dans l'admin : la validation se fait par
le DNS. L'ecran Referencement rappelle la procedure au client.

### 3 ter. Purge automatique des statistiques (cron OVH)

Les stats gardent 13 mois de detail. Sans purge, `page_view` et
`stat_session` grossissent sans fin (bw_pro_dici : 11 Go en octobre 2026,
surtout des robots). `app:stat:purge` supprime par paquets, sans bloquer la
base.

1. Espace client OVH → Hebergement → onglet **Taches planifiees - Cron** →
   **Ajouter une planification**.
2. Commande a executer : `scripts/cron-stat-purge.php` (chemin depuis la
   racine du compte FTP, a adapter si le projet est dans un sous-dossier).
3. Langage : **PHP 8.4**. Frequence : **une fois par semaine**, la nuit.
4. Activer les alertes e-mail en cas d'erreur.

Tester a la main avant de planifier :
```bash
php bin/console app:stat:purge --dry-run --env=prod
```

Les robots ne sont plus enregistres visite par visite : ils sont comptes par
jour dans `stat_bot_daily` (courbe « Robots » de l'accueil de l'admin).

Une visite n'est enregistree que si le navigateur la confirme : la page porte
un ticket signe (`<meta name="bw-visit">`), `stat-tracker.js` le renvoie a
`/api/vue`. Un robot qui n'execute pas le JavaScript ne laisse aucune ligne,
meme avec un user-agent de navigateur et des milliers d'IP (bw_pro_dici,
octobre 2026). Apres un deploy, verifier que la balise est dans le code
source d'une page publique, vue sans etre connecte a l'admin.

### 4. Mises a jour

Quand main evolue (nouvelle feature CMS), depuis Git Bash ou WSL :

```bash
# En local : merge tactique, migrations sur la base du client, build,
# tests, controle des pages, push. S'arrete au moindre souci, sans pousser.
./scripts/client.sh update bw_nom_client

# Sur OVH, sans se connecter a la main (DEPLOY_SSH et DEPLOY_DIR dans
# .env.bw_nom_client.local) : pull + composer + assets + cache + migrations,
# puis controles (entrees du build, pages en 200, erreurs critiques)
./scripts/client.sh deploy bw_nom_client
```

`./scripts/client.sh switch bw_nom_client` change seulement de client (branche,
`.env.local`, cache). Le script refuse toute base qui n'est pas celle de la
branche : jamais les migrations d'une branche sur la base d'une autre.

Un conflit au merge vient presque toujours d'une surcouche du client
(`templates/client/`, ou `public/.htaccess` sur bw_lintello) : la resoudre, committer,
relancer `update`.

### Domaine principal et https

- `public/.htaccess` redirige tout le http vers le https (test `%{SERVER_PORT}`,
  le seul fiable derriere le frontal OVH).
- `APP_PRIMARY_HOST` dans le `.env.local` du serveur (demande par `--init`) :
  domaine nu, www et anciennes preprod repartent en 301 vers ce domaine.
  Sans lui, `deploy-ovh.sh` previent a chaque deploy.

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
| MAILER_DSN | `brevo+api://CLE_API@default` (cle API commune ComWeb) | Emails transactionnels (expediteur: noreply@comwebsolutions.fr) |
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
- [ ] Fiche Referencement remplie dans l'admin (activite, cible, atouts, portee,
      villes, priorites, mots des clients) et bilan relu — elle part avec le dump

## Checklist post-deploy

- [ ] Domaine racine ET www repondent en HTTPS, l'un redirige vers l'autre (301) :
      `APP_PRIMARY_HOST` regle, certificat SSL regenere apres ajout du multisite
- [ ] Propriete **Domaine** creee dans Google Search Console, TXT a la racine, validee (section 3 bis)
- [ ] `/sitemap.xml` envoye dans Search Console, toutes ses URL en 200
- [ ] Indexation de la home demandee
- [ ] Cron de purge des statistiques planifie, une fois par semaine (section 3 ter)

---

## Problemes connus et solutions

| Probleme | Cause | Solution |
|----------|-------|----------|
| `PHP 4.4.9` ou `5.4` en SSH | .ovhconfig manquant ou pas appliqué | `.ovhconfig` deja dans le repo, **reconnexion SSH obligatoire** apres clone pour appliquer |
| `/bin/bash^M : mauvais interpreteur` | Script .sh commit avec CRLF (Windows) | `sed -i 's/\r$//' scripts/deploy-ovh.sh` puis relancer. **Fixe sur main depuis le deploy APA d'Bearn** (deploy-ovh.sh re-commit en LF). Si reapparait sur un autre script : meme commande |
| `npm ci` echoue : `Missing X from lock file` | Bug ambient OVH mutualise : peer deps resolues differemment (`tsx`, `vitest`, `esbuild`...) malgre un lock file en sync local | **Fixe sur main depuis APA d'Bearn** : le script utilise `npm install` au lieu de `npm ci`. Plus tolerant, fonctionne meme quand npm exige des peer deps non listees dans le lock |
| `Error: listen EACCES 0.0.0.0` (sync-rpc) | OVH mutualise restreint l'ouverture de ports par les processes Node (sync-rpc essaie de bind un port) | Le script `deploy-ovh.sh` applique automatiquement le patch eslint.js apres `npm ci`. **Si tu fais `npm install` manuellement** (suite a un `npm ci` echoue), il faut **rappliquer le patch** avant `encore production` : `sed -i "s\|^const forceSync\|//const forceSync\|" node_modules/@symfony/webpack-encore/lib/plugins/eslint.js && sed -i "s\|^const hasEslintConfiguration = forceSync\|//const hasEslintConfiguration = forceSync\|" node_modules/@symfony/webpack-encore/lib/plugins/eslint.js` |
| `DebugBundle not found` | APP_ENV pas prod | Script exporte APP_ENV=prod auto |
| `enabled_modules can't have default` | MySQL 8 strict | --import corrige auto, --init skip migrations si dump |
| `utf8mb4_uca1400_ai_ci` | MariaDB vs MySQL | --import convertit auto |
| `No such file or directory` BDD | .env.prod ecrase DATABASE_URL | .env.prod supprime du repo |
| `MESSENGER_TRANSPORT_DSN` corrompu | Erreur manuelle | --init genere un .env.local propre |
| Conflits au merge | Fichiers modifies des 2 cotes | Override dans templates/client/, merge sans conflit |
| OVH cree un dossier `public/` par defaut au cluster | Multisite OVH ajoute un public/ vide dans le home | `rmdir public` **avant** le `git clone .` (sinon "destination path '.' already exists and is not an empty directory") |
| Connection refused vers la BDD CloudDB | IP de l'hebergement mutualise pas dans la whitelist | OVH > Cloud DB > IPs autorisees → ajouter l'IP du mutualise (visible dans les infos hebergement) |

---

## En cas d'echec partiel du `--init`

**Pas de rollback automatique.** Le script est en `set -euo pipefail` : si une etape plante, tout s'arrete dans l'etat en cours. Recap des etapes :

1. Pull du code
2. Verification conflits Git
3. Composer install (`[3/7]`)
4. Installation Node + nvm (`[4/7]`)
5. **Build assets : `npm ci` puis `encore production` (`[5/7]`)** ← echec frequent ici
6. Cache Symfony clear + warmup (`[6/7]`)
7. Migrations OU import dump (`[7/7]`)

**Reprendre apres une erreur a l'etape 5 (sans relancer `--init` qui ecraserait `.env.local`) :**

```bash
# Sourcer nvm (sinon node pas dispo dans la session)
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"

# 1. Build assets (toujours npm install, jamais npm ci sur OVH mutualise)
npm install
sed -i "s|^const forceSync|//const forceSync|" node_modules/@symfony/webpack-encore/lib/plugins/eslint.js
sed -i "s|^const hasEslintConfiguration = forceSync|//const hasEslintConfiguration = forceSync|" node_modules/@symfony/webpack-encore/lib/plugins/eslint.js
NODE_ENV=production npm run build

# 2. Cache Symfony
APP_ENV=prod php bin/console cache:clear --env=prod --no-debug
APP_ENV=prod php bin/console cache:warmup --env=prod --no-debug

# 3. Import du dump
./scripts/deploy-ovh.sh --import scripts/bw_<client>_dump.sql
```
