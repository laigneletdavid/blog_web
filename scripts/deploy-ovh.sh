#!/bin/bash
# BlogWeb — Script de deploiement manuel pour OVH mutualise
# Usage: ssh user@host puis ./deploy-ovh.sh
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

echo "=== BlogWeb — Deploy OVH ==="

# --- 0. Forcer l'environnement prod ---
export APP_ENV=prod
export APP_DEBUG=0

# --- 1. Verifier PHP ---
PHP_VER=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
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
    echo "ERREUR: .env.local manquant ! Copier .env.local.example et configurer."
    exit 1
fi
if grep -q 'APP_SECRET=$' .env.local || grep -q 'APP_SECRET=CHANGE_ME' .env.local; then
    SECRET=$(php -r "echo bin2hex(random_bytes(16));")
    sed -i "s|APP_SECRET=.*|APP_SECRET=$SECRET|" .env.local
    echo "       APP_SECRET genere automatiquement"
fi

# --- 5. Composer ---
echo "[3/7] Dependances PHP..."
if [ ! -f composer.phar ]; then
    echo "       Installation de composer..."
    curl -sS https://getcomposer.org/installer | php
fi
php composer.phar install --no-dev --optimize-autoloader --no-interaction

# --- 6. Node + Assets ---
echo "[4/7] Installation Node (nvm)..."
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
. "$NVM_DIR/nvm.sh"
nvm install 20 2>/dev/null || true
nvm use 20

echo "[5/7] Build des assets..."
npm ci

# Patch sync-rpc (contournement restriction ports OVH mutualise)
ESLINT_FILE="node_modules/@symfony/webpack-encore/lib/plugins/eslint.js"
if [ -f "$ESLINT_FILE" ] && grep -q "^const forceSync" "$ESLINT_FILE"; then
    sed -i "s|^const forceSync|//const forceSync|" "$ESLINT_FILE"
    sed -i "s|^const hasEslintConfiguration = forceSync|//const hasEslintConfiguration = forceSync|" "$ESLINT_FILE"
    echo "       Patch sync-rpc applique"
fi
NODE_ENV=production npx encore production

# --- 7. Symfony ---
echo "[6/7] Cache Symfony..."
APP_ENV=prod php bin/console cache:clear --env=prod --no-debug
APP_ENV=prod php bin/console cache:warmup --env=prod --no-debug

echo "[7/7] Migrations BDD..."
APP_ENV=prod php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

echo ""
echo "=== Deploy termine ! ==="
