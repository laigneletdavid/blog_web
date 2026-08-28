#!/bin/bash
# BlogWeb — Script de deploiement pour OVH mutualise
# Usage:
#   Premier deploy : ./scripts/deploy-ovh.sh --init
#   Mises a jour   : ./scripts/deploy-ovh.sh
#   Import dump    : ./scripts/deploy-ovh.sh --import dump.sql
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

# --- 0. Forcer l'environnement prod ---
export APP_ENV=prod
export APP_DEBUG=0

# --- 0 bis. Trouver un PHP en ligne de commande ---
# Sur OVH mutualise, « php » est le binaire CGI : il refuse -r avec
# « Error in argument 1, char 2: option not found r ». Le CLI existe, mais
# sous un autre nom selon l'offre. On prend le premier qui sait executer -r.
detecter_php() {
    local candidat
    for candidat in "${PHP_BIN:-}" php php-cli php8.4 php84         /usr/local/php8.4/bin/php /usr/local/php/8.4/bin/php         /usr/local/bin/php-cli /usr/bin/php-cli; do
        [ -n "$candidat" ] || continue
        command -v "$candidat" >/dev/null 2>&1 || [ -x "$candidat" ] || continue
        # On compare la sortie, pas le code retour : le CGI peut sortir 0
        # tout en emettant ses en-tetes HTTP a la place du resultat.
        if [ "$("$candidat" -r 'echo "ok";' 2>/dev/null)" = "ok" ]; then
            printf '%s' "$candidat"
            return 0
        fi
    done
    return 1
}

if ! PHP_BIN=$(detecter_php); then
    echo "ERREUR: aucun PHP en ligne de commande utilisable."
    echo "Le « php » du PATH est le binaire CGI : il ne comprend pas -r."
    echo "Chercher le CLI avec : ls /usr/local/php*/bin/php"
    echo "puis relancer avec :   PHP_BIN=/chemin/vers/php $0 ${*:-}"
    exit 1
fi
echo "[php] $PHP_BIN"


# =============================================================================
# MODE --init : Premier deploiement (genere .env.local, teste BDD, etc.)
# =============================================================================
if [[ "${1:-}" == "--init" ]]; then
    echo "=== BlogWeb — Init OVH ==="

    # Verifier PHP
    PHP_VER=$("$PHP_BIN" -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    echo "[check] PHP $PHP_VER"
    if [[ "$PHP_VER" != "8.4" ]]; then
        echo "ERREUR: PHP 8.4 requis (actuel: $PHP_VER)"
        echo "Verifier .ovhconfig et se reconnecter en SSH"
        exit 1
    fi

    # Generer .env.local
    if [ -f .env.local ]; then
        echo "[!] .env.local existe deja. Ecraser ? (y/N)"
        read -r REPLY
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
            echo "Init annule."
            exit 0
        fi
    fi

    echo ""
    echo "--- Configuration BDD ---"
    read -rp "Host BDD (ex: ld60352-001.eu.clouddb.ovh.net) : " DB_HOST
    read -rp "Port BDD (ex: 35547) : " DB_PORT
    read -rp "Nom utilisateur BDD : " DB_USER
    read -rsp "Mot de passe BDD : " DB_PASS
    echo ""
    read -rp "Nom de la base : " DB_NAME

    # Tester la connexion BDD
    echo ""
    echo "[test] Connexion BDD..."
    if "$PHP_BIN" -r "new PDO('mysql:host=$DB_HOST;port=$DB_PORT;dbname=$DB_NAME', '$DB_USER', '$DB_PASS');" 2>/dev/null; then
        echo "[OK] Connexion BDD reussie"
    else
        echo "ERREUR: Impossible de se connecter a la BDD."
        echo "Verifier les credentials et les IP autorisees sur CloudDB OVH."
        exit 1
    fi

    echo ""
    echo "--- Configuration Mailer ---"
    # Chercher un MAILER_DSN existant dans les autres sites BlogWeb du meme hebergement
    EXISTING_DSN=""
    for envfile in "$HOME"/*/.env.local; do
        [ -f "$envfile" ] || continue
        [ "$envfile" = "$SITE_DIR/.env.local" ] && continue
        DSN_FOUND=$(grep '^MAILER_DSN=' "$envfile" 2>/dev/null | head -1 | sed 's/MAILER_DSN=//')
        if [ -n "$DSN_FOUND" ] && [ "$DSN_FOUND" != "smtp://localhost:1025" ]; then
            EXISTING_DSN="$DSN_FOUND"
            echo "[auto] MAILER_DSN trouve dans $(basename "$(dirname "$envfile")")/.env.local"
            break
        fi
    done
    if [ -n "$EXISTING_DSN" ]; then
        echo "       → $EXISTING_DSN"
        echo "       Utiliser ce DSN ? (Y/n)"
        read -r REPLY
        if [[ "$REPLY" =~ ^[Nn]$ ]]; then
            read -rp "MAILER_DSN Brevo : " MAILER_DSN
            MAILER_DSN="${MAILER_DSN:-smtp://localhost:1025}"
        else
            MAILER_DSN="$EXISTING_DSN"
        fi
    else
        read -rp "MAILER_DSN Brevo (laisser vide pour skip) : " MAILER_DSN
        MAILER_DSN="${MAILER_DSN:-smtp://localhost:1025}"
    fi

    # Generer APP_SECRET
    APP_SECRET=$("$PHP_BIN" -r "echo bin2hex(random_bytes(16));")

    # Ecrire .env.local
    cat > .env.local << ENVEOF
###> symfony/framework-bundle ###
APP_ENV=prod
APP_SECRET=$APP_SECRET
###< symfony/framework-bundle ###

###> doctrine/doctrine-bundle ###
DATABASE_URL="mysql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME?serverVersion=8.0&charset=utf8mb4"
###< doctrine/doctrine-bundle ###

###> symfony/messenger ###
MESSENGER_TRANSPORT_DSN=doctrine://default
###< symfony/messenger ###

###> symfony/mailer ###
MAILER_DSN=$MAILER_DSN
###< symfony/mailer ###

###> recaptcha ###
RECAPTCHA_SITE_KEY=
RECAPTCHA_SECRET_KEY=
###< recaptcha ###
ENVEOF

    echo ""
    echo "[OK] .env.local genere"
    echo ""

    # Supprimer .env.prod si present (ecrase les valeurs)
    if [ -f .env.prod ]; then
        rm -f .env.prod
        echo "[fix] .env.prod supprime (evite ecrasement des valeurs)"
    fi

    # Dump SQL a importer ?
    echo ""
    read -rp "Chemin du dump SQL a importer (laisser vide pour skip) : " DUMP_PATH
    echo ""

    # Lancer le deploy (skip migrations si dump prevu)
    echo "--- Lancement du deploy ---"
    echo ""
    if [ -n "$DUMP_PATH" ]; then
        exec "$0" --skip-migrations "$DUMP_PATH"
    else
        exec "$0"
    fi
fi

# =============================================================================
# MODE --import : Importer un dump SQL
# =============================================================================
if [[ "${1:-}" == "--import" ]]; then
    DUMP_FILE="${2:-}"
    if [ -z "$DUMP_FILE" ] || [ ! -f "$DUMP_FILE" ]; then
        echo "Usage: $0 --import <fichier.sql>"
        exit 1
    fi

    # Verifier que c'est du SQL
    if ! head -5 "$DUMP_FILE" | grep -qi 'sql\|mariadb\|mysql\|create\|insert'; then
        echo "ERREUR: Le fichier ne semble pas etre un dump SQL valide."
        head -3 "$DUMP_FILE"
        exit 1
    fi

    # Extraire les credentials depuis .env.local
    if [ ! -f .env.local ]; then
        echo "ERREUR: .env.local manquant. Lancer --init d'abord."
        exit 1
    fi

    DB_URL=$(grep '^DATABASE_URL=' .env.local | sed 's/DATABASE_URL=//' | tr -d '"')
    # Parse: mysql://user:pass@host:port/dbname
    DB_USER=$(echo "$DB_URL" | sed 's|mysql://||' | cut -d: -f1)
    DB_PASS=$(echo "$DB_URL" | sed 's|mysql://||' | cut -d: -f2 | cut -d@ -f1)
    DB_HOST=$(echo "$DB_URL" | cut -d@ -f2 | cut -d: -f1)
    DB_PORT=$(echo "$DB_URL" | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f1)
    DB_NAME=$(echo "$DB_URL" | cut -d/ -f4 | cut -d? -f1)

    echo "=== Import dump SQL ==="
    echo "Fichier : $DUMP_FILE"
    echo "BDD     : $DB_NAME@$DB_HOST:$DB_PORT"
    echo ""
    echo "ATTENTION: Cela va ecraser les donnees existantes. Continuer ? (y/N)"
    read -r REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Import annule."
        exit 0
    fi

    # Fix compatibilite MariaDB → MySQL 8
    echo "[fix] Conversion dump MariaDB → MySQL..."
    IMPORT_FILE="/tmp/dump_fixed.sql"
    sed -e '/^\/\*M!999999/d' \
        -e 's/utf8mb4_uca1400_ai_ci/utf8mb4_unicode_ci/g' \
        -e "s/ DEFAULT '\\[.*\\]' CHECK (json_valid(\`[^\`]*\`))//g" \
        -e 's/ CHECK (json_valid(`[^`]*`))//g' \
        "$DUMP_FILE" > "$IMPORT_FILE"

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$IMPORT_FILE"
    [ "$IMPORT_FILE" != "$DUMP_FILE" ] && rm -f "$IMPORT_FILE"
    echo "[OK] Dump importe avec succes"
    exit 0
fi

# =============================================================================
# MODE --skip-migrations : Deploy sans migrations (dump prevu)
# =============================================================================
SKIP_MIGRATIONS=false
DUMP_TO_IMPORT=""
if [[ "${1:-}" == "--skip-migrations" ]]; then
    SKIP_MIGRATIONS=true
    DUMP_TO_IMPORT="${2:-}"
fi

# =============================================================================
# MODE NORMAL : Mise a jour (deploy)
# =============================================================================
echo "=== BlogWeb — Deploy OVH ==="

# --- 1. Verifier PHP ---
PHP_VER=$("$PHP_BIN" -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "[check] PHP $PHP_VER"
if [[ "$PHP_VER" != "8.4" ]]; then
    echo "ERREUR: PHP 8.4 requis (actuel: $PHP_VER)"
    echo "Verifier .ovhconfig et se reconnecter en SSH"
    exit 1
fi

# --- 2. Pull ---
echo "[1/7] Pull du code..."
git pull --ff-only

# --- 3. Marqueurs de conflit ---
echo "[2/7] Verification des conflits Git..."
if grep -rn '^<<<<<<< \|^=======\|^>>>>>>> ' assets/ src/ templates/ config/ 2>/dev/null; then
    echo "ERREUR: Marqueurs de conflit Git detectes !"
    exit 1
fi

# --- 4. .env.local check (avant composer pour que auto-scripts fonctionne) ---
if [ ! -f .env.local ]; then
    echo "ERREUR: .env.local manquant ! Lancer: ./scripts/deploy-ovh.sh --init"
    exit 1
fi
if grep -q 'APP_SECRET=$' .env.local || grep -q 'APP_SECRET=CHANGE_ME' .env.local; then
    SECRET=$("$PHP_BIN" -r "echo bin2hex(random_bytes(16));")
    sed -i "s|APP_SECRET=.*|APP_SECRET=$SECRET|" .env.local
    echo "       APP_SECRET genere automatiquement"
fi

# Supprimer .env.prod si present (ecrase les valeurs de .env.local)
[ -f .env.prod ] && rm -f .env.prod && echo "       .env.prod supprime"

# --- 5. Composer ---
echo "[3/7] Dependances PHP..."
if [ ! -f composer.phar ]; then
    echo "       Installation de composer..."
    curl -sS https://getcomposer.org/installer | php
fi
"$PHP_BIN" composer.phar install --no-dev --optimize-autoloader --no-interaction

# --- 6. Node + Assets ---
echo "[4/7] Installation Node (nvm)..."
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Sans profil de connexion, l'installateur de nvm renonce a s'y declarer et
# nvm reste introuvable des qu'on ouvre une session SSH : node et npm ne
# vivent alors que le temps de ce script. On pose les deux fichiers que bash
# lit -- .bashrc en session interactive, .profile en shell de login -- sans
# jamais ecraser ceux qui existent deja.
for profil in "$HOME/.bashrc" "$HOME/.profile"; do
    if [ ! -f "$profil" ]; then
        printf '%s
' 'export NVM_DIR="$HOME/.nvm"'             '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' > "$profil"
        chmod 644 "$profil"
        echo "       $(basename "$profil") cree (chargement de nvm)"
    elif ! grep -q 'NVM_DIR' "$profil"; then
        printf '
%s
' 'export NVM_DIR="$HOME/.nvm"'             '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> "$profil"
        echo "       $(basename "$profil") complete (chargement de nvm)"
    fi
done

. "$NVM_DIR/nvm.sh"
nvm install 20 2>/dev/null || true
nvm use 20

echo "[5/7] Build des assets..."

# OVH mutualise plafonne bas le nombre de fichiers ouverts simultanement. npm
# en ouvre beaucoup pour son cache et s'arrete sur « EMFILE: too many open
# files ». On remonte a la limite dure du compte et on serre la concurrence.
LIMITE_DURE=$(ulimit -Hn 2>/dev/null || echo "")
if [ -n "$LIMITE_DURE" ]; then
    if [ "$LIMITE_DURE" = "unlimited" ]; then
        ulimit -n 8192 2>/dev/null || true
    else
        ulimit -n "$LIMITE_DURE" 2>/dev/null || true
    fi
fi
echo "       fichiers ouverts autorises : $(ulimit -n)"
npm config set maxsockets 1 >/dev/null 2>&1 || true

# npm install (et pas npm ci) : sur OVH mutualise, npm ci echoue
# systematiquement avec "Missing X from lock file" (peer deps resolues
# differemment selon l'env). npm install est plus tolerant et fonctionne.
if ! npm install --no-audit --no-fund; then
    echo ""
    echo "ERREUR: npm install a echoue."
    echo "Si le message parle de EMFILE, vider le cache et reessayer :"
    echo "  npm cache clean --force && ./scripts/deploy-ovh.sh"
    exit 1
fi

# Patch sync-rpc (contournement restriction ports OVH mutualise)
ESLINT_FILE="node_modules/@symfony/webpack-encore/lib/plugins/eslint.js"
if [ -f "$ESLINT_FILE" ] && grep -q "^const forceSync" "$ESLINT_FILE"; then
    sed -i "s|^const forceSync|//const forceSync|" "$ESLINT_FILE"
    sed -i "s|^const hasEslintConfiguration = forceSync|//const hasEslintConfiguration = forceSync|" "$ESLINT_FILE"
    echo "       Patch sync-rpc applique"
fi
NODE_ENV=production npm run build

# --- 7. Symfony ---
echo "[6/7] Cache Symfony..."
APP_ENV=prod "$PHP_BIN" bin/console cache:clear --env=prod --no-debug
APP_ENV=prod "$PHP_BIN" bin/console cache:warmup --env=prod --no-debug

if [ "$SKIP_MIGRATIONS" = true ]; then
    echo "[7/7] Skip migrations (dump prevu)..."
    if [ -n "$DUMP_TO_IMPORT" ] && [ -f "$DUMP_TO_IMPORT" ]; then
        echo "       Import du dump..."
        exec "$0" --import "$DUMP_TO_IMPORT"
    fi
else
    echo "[7/7] Migrations BDD..."
    APP_ENV=prod "$PHP_BIN" bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
fi

echo ""
echo "=== Deploy termine ! ==="
