#!/bin/bash
# Blog Web — Database backup script
# Usage: ./scripts/backup.sh
# Cron: 0 2 * * * cd /var/www/clients/client-x && ./scripts/backup.sh

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/var/backups/blog_web}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/blog_web_${TIMESTAMP}.sql.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Read database credentials from .env.local or .env
if [ -f .env.local ]; then
    DB_URL=$(grep '^DATABASE_URL=' .env.local | cut -d '=' -f 2- | tr -d '"' | tr -d "'")
fi
if [ -z "${DB_URL:-}" ] && [ -f .env ]; then
    DB_URL=$(grep '^DATABASE_URL=' .env | cut -d '=' -f 2- | tr -d '"' | tr -d "'")
fi

if [ -z "${DB_URL:-}" ]; then
    echo "ERROR: DATABASE_URL not found in .env.local or .env"
    exit 1
fi

# Parse DATABASE_URL (mysql://user:pass@host:port/dbname)
DB_USER=$(echo "$DB_URL" | sed -E 's|.*://([^:]+):.*|\1|')
DB_PASS=$(echo "$DB_URL" | sed -E 's|.*://[^:]+:([^@]+)@.*|\1|')
DB_HOST=$(echo "$DB_URL" | sed -E 's|.*@([^:]+):.*|\1|')
DB_PORT=$(echo "$DB_URL" | sed -E 's|.*:([0-9]+)/.*|\1|')
DB_NAME=$(echo "$DB_URL" | sed -E 's|.*/([^?]+).*|\1|')

echo "Backing up database '${DB_NAME}' to ${BACKUP_FILE}..."

# Dump via Docker container
docker compose exec -T db mysqldump \
    -u"$DB_USER" \
    -p"$DB_PASS" \
    --single-transaction \
    --routines \
    --triggers \
    "$DB_NAME" | gzip > "$BACKUP_FILE"

# Verify backup
if [ -s "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "OK: Backup created (${SIZE}): ${BACKUP_FILE}"
else
    echo "ERROR: Backup file is empty"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Rotate old backups
DELETED=$(find "$BACKUP_DIR" -name "blog_web_*.sql.gz" -mtime +${RETENTION_DAYS} -delete -print | wc -l)
if [ "$DELETED" -gt 0 ]; then
    echo "Cleaned up ${DELETED} backup(s) older than ${RETENTION_DAYS} days."
fi
