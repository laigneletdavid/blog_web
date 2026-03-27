#!/bin/bash
# Blog Web — Deployment script
# Usage: ./scripts/deploy.sh

set -euo pipefail

DOCKER="docker compose -f docker-compose.yml -f docker-compose.prod.yml"
PHP="$DOCKER exec -T php"

echo "=== Blog Web — Deployment ==="

# 0. Remove dev documentation files if present
DEV_FILES="CLAUDE.md CLAUDE2.md CLAUDE_FULL.md PLAN.md DESIGN_THEME.md audit_cms_claude_code.md"
for f in $DEV_FILES; do
    [ -f "$f" ] && rm -f "$f" && echo "Cleaned: $f"
done
[ -d ".claude/docs" ] && rm -rf ".claude/docs" && echo "Cleaned: .claude/docs/"

# 1. Pull latest code
echo "[1/6] Pulling latest code..."
git pull --ff-only

# 2. Install PHP dependencies (no dev)
echo "[2/6] Installing PHP dependencies..."
$PHP composer install --no-dev --optimize-autoloader --no-interaction

# 3. Run migrations with rollback on failure
echo "[3/6] Running database migrations..."
MIGRATION_OUTPUT=$($PHP php bin/console doctrine:migrations:migrate --no-interaction 2>&1) || {
    echo "ERROR: Migration failed!"
    echo "$MIGRATION_OUTPUT"
    echo "Rolling back..."
    $PHP php bin/console doctrine:migrations:migrate prev --no-interaction 2>/dev/null || true
    exit 1
}
echo "$MIGRATION_OUTPUT"

# 4. Clear cache
echo "[4/6] Clearing cache..."
$PHP php bin/console cache:clear --env=prod
$PHP php bin/console cache:warmup --env=prod

# 5. Build assets
echo "[5/6] Building assets..."
$DOCKER run --rm -w /var/www/html node npm install
$DOCKER run --rm -w /var/www/html node npm run build

# 6. Restart services
echo "[6/6] Restarting services..."
$DOCKER restart php nginx

echo "=== Deployment complete ==="
