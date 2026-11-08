#!/bin/bash
# =============================================================================
# BlogWeb — Exporte le CONTENU d'une base locale pour le pousser sur la prod
#
# Cas d'usage : on retravaille un site en local (pages, FAQ, realisations,
# articles, medias, reglages) sur une copie de la base de prod, puis on renvoie
# ce contenu en ligne SANS toucher a ce que la prod a accumule de son cote :
# comptes, messages, abonnes, commentaires, likes, commandes, statistiques.
#
# Pour chaque table de contenu, le fichier vide la table puis reinsere les
# lignes locales : la prod devient identique au local pour le contenu.
# Les verifications de cles etrangeres sont coupees pendant l'import ; en
# MySQL/MariaDB, cela coupe aussi les ON DELETE CASCADE : vider « article »
# n'efface donc ni ses commentaires ni ses statistiques.
#
# A n'utiliser que si le contenu de la prod n'a pas bouge depuis la copie
# locale : une page modifiee en ligne entre-temps serait remplacee.
#
# Usage :
#   ./scripts/export-contenu.sh                 # base lue dans .env.local
#   ./scripts/export-contenu.sh bw_front        # base explicite
# Sortie : var/contenu_<base>_<date>.sql (var/ n'est pas versionne).
#
# Sur le serveur, apres le deploiement du code (migrations passees) :
#   ./scripts/deploy-ovh.sh --import ~/contenu_<base>_<date>.sql
# =============================================================================
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"

# --- Tables qui restent sur la prod (jamais exportees) ---
TABLES_PROD=(
    user                        # comptes
    reset_password_request      # jetons
    contact_message             # messages du formulaire
    subscriber                  # abonnes
    comment                     # commentaires des visiteurs
    like                        # likes des visiteurs
    "order"                     # commandes
    stat_session                # statistiques
    page_view                   # statistiques
    stat_conversion             # statistiques
    stat_bot_daily              # statistiques
    messenger_messages          # file d'attente
    doctrine_migration_versions # etat des migrations de la prod
)

# --- Base source ---
BASE="${1:-}"
if [ -z "$BASE" ]; then
    [ -f .env.local ] || { echo "ERREUR: .env.local introuvable, passer le nom de la base en argument."; exit 1; }
    URL=$(grep '^DATABASE_URL=' .env.local | head -1 | sed 's/^DATABASE_URL=//' | tr -d '"')
    BASE=$(echo "$URL" | cut -d/ -f4 | cut -d? -f1)
    USER_BDD=$(echo "$URL" | sed 's|mysql://||' | cut -d: -f1)
    PASS_BDD=$(echo "$URL" | sed 's|mysql://||' | cut -d: -f2 | cut -d@ -f1)
else
    USER_BDD="${DB_USER:-app}"
    PASS_BDD="${DB_PASS:-app}"
fi
[ -n "$BASE" ] || { echo "ERREUR: base introuvable."; exit 1; }

if docker compose ps db >/dev/null 2>&1 && [ -n "$(docker compose ps -q db 2>/dev/null)" ]; then
    client() { docker compose exec -T db mariadb -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
    dumper() { docker compose exec -T db mariadb-dump -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
else
    CLI=$(command -v mariadb || command -v mysql || true)
    OUTIL=$(command -v mariadb-dump || command -v mysqldump || true)
    [ -n "$CLI" ] && [ -n "$OUTIL" ] || { echo "ERREUR: client MySQL/MariaDB introuvable."; exit 1; }
    client() { "$CLI" -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
    dumper() { "$OUTIL" -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
fi

# --- Tables de contenu = toutes, sauf celles de la prod ---
CONTENU=()
while read -r t; do
    garde=1
    for p in "${TABLES_PROD[@]}"; do [ "$t" = "${p//\"/}" ] && garde=0; done
    [ "$garde" = 1 ] && CONTENU+=("$t")
done < <(client -N -e "SHOW TABLES" "$BASE" | tr -d '\r')

[ "${#CONTENU[@]}" -gt 0 ] || { echo "ERREUR: aucune table de contenu trouvee dans $BASE."; exit 1; }

mkdir -p var
SORTIE="var/contenu_${BASE}_$(date +%Y%m%d_%H%M).sql"

{
    # « MySQL » en tete : deploy-ovh.sh --import cherche sql/mysql/insert dans les 5 premieres lignes
    echo "-- MySQL / MariaDB : contenu de la base $BASE, exporte le $(date '+%d/%m/%Y %H:%M') par scripts/export-contenu.sh"
    echo "-- Tables remplacees : ${CONTENU[*]}"
    echo "-- Tables jamais touchees : ${TABLES_PROD[*]//\"/}"
    echo "SET NAMES utf8mb4;"
    echo "SET FOREIGN_KEY_CHECKS=0;"
    echo "SET UNIQUE_CHECKS=0;"
    for t in "${CONTENU[@]}"; do
        echo ""
        echo "DELETE FROM \`$t\`;"
        dumper --single-transaction --no-tablespaces --default-character-set=utf8mb4 \
            --no-create-info --skip-add-drop-table --skip-triggers --complete-insert \
            --skip-comments --compact "$BASE" "$t"
    done
    echo ""
    echo "SET UNIQUE_CHECKS=1;"
    echo "SET FOREIGN_KEY_CHECKS=1;"
} > "$SORTIE"

# --- Garde-fous : rien de personnel ne doit sortir ---
FUITE=0
for p in "${TABLES_PROD[@]}"; do
    nom="${p//\"/}"
    if grep -qE "^(INSERT INTO|DELETE FROM) \`${nom}\`" "$SORTIE"; then
        echo "  ALERTE: la table « $nom » figure dans l'export."
        FUITE=1
    fi
done
if grep -qE '\$2[aby]\$[0-9]+\$' "$SORTIE"; then
    echo "  ALERTE: une empreinte de mot de passe figure dans l'export."
    FUITE=1
fi
[ "$FUITE" = 0 ] || { rm -f "$SORTIE"; echo "Export annule."; exit 1; }

echo "[OK] $SORTIE — $(du -h "$SORTIE" | cut -f1), ${#CONTENU[@]} tables de contenu, $(grep -c '^INSERT INTO' "$SORTIE") insertions"
echo "     Restent sur la prod : ${TABLES_PROD[*]//\"/}"
echo "     Les fichiers des medias (public/documents/medias) sont a envoyer a part."
