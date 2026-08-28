#!/bin/bash
# BlogWeb — Fabrique le dump de deploiement d'une branche client
#
# Le dump voyage avec la branche, dans scripts/, et le deploiement l'y trouve.
# Comme le depot est public, il ne doit contenir aucune donnee personnelle :
# ce script exporte la structure complete, puis les seules donnees de contenu.
# Les tables nominatives -- comptes, messages, abonnes, statistiques -- gardent
# leur structure mais partent vides.
#
# Usage:
#   ./scripts/make-deploy-dump.sh                 # base lue dans .env.local
#   ./scripts/make-deploy-dump.sh bw_mainguy      # base explicite
set -euo pipefail

cd "$(cd "$(dirname "$0")/.." && pwd)"

# --- Tables dont les donnees ne sortent jamais du serveur ---
# Le contenu editorial voyage ; ce qui identifie une personne, non.
TABLES_SANS_DONNEES=(
    user                    # emails et empreintes de mots de passe
    reset_password_request  # jetons de reinitialisation
    contact_message         # demandes envoyees par le formulaire
    subscriber              # abonnes aux notifications
    comment                 # commentaires et leurs auteurs
    stat_session            # navigation
    page_view               # navigation
    stat_conversion         # navigation
    "order"                 # commandes
    messenger_messages      # file d'attente
)

# --- Base cible ---
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

SORTIE="scripts/${BASE}_dump.sql"

# --- Comment joindre le serveur MySQL ---
# En developpement la base vit dans un conteneur ; ailleurs, on prend le
# client installe sur la machine.
if docker compose ps db >/dev/null 2>&1 && [ -n "$(docker compose ps -q db 2>/dev/null)" ]; then
    dumper() { docker compose exec -T db mariadb-dump -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
    echo "[source] conteneur docker « db »"
else
    OUTIL=$(command -v mariadb-dump || command -v mysqldump || true)
    [ -n "$OUTIL" ] || { echo "ERREUR: ni conteneur db, ni mysqldump/mariadb-dump."; exit 1; }
    dumper() { "$OUTIL" -u"$USER_BDD" -p"$PASS_BDD" "$@"; }
    echo "[source] $OUTIL"
fi

COMMUN=(--single-transaction --no-tablespaces --default-character-set=utf8mb4)

echo "[1/3] Structure des tables..."
dumper "${COMMUN[@]}" --no-data "$BASE" > "$SORTIE"

echo "[2/3] Donnees de contenu..."
IGNORE=()
for t in "${TABLES_SANS_DONNEES[@]}"; do
    IGNORE+=(--ignore-table="${BASE}.${t//\"/}")
done
dumper "${COMMUN[@]}" --no-create-info --skip-add-drop-table "${IGNORE[@]}" "$BASE" >> "$SORTIE"

echo "[3/3] Verification..."
FUITE=0
for t in "${TABLES_SANS_DONNEES[@]}"; do
    nom="${t//\"/}"
    if grep -q "^INSERT INTO \`${nom}\`" "$SORTIE"; then
        echo "  ALERTE: des donnees de « $nom » figurent dans le dump."
        FUITE=1
    fi
done
if grep -qE '\$2[aby]\$[0-9]+\$' "$SORTIE"; then
    echo "  ALERTE: une empreinte de mot de passe figure dans le dump."
    FUITE=1
fi
[ "$FUITE" = "0" ] || { echo ""; echo "Dump non publiable, il n'est pas ecrit."; rm -f "$SORTIE"; exit 1; }

TAILLE=$(du -h "$SORTIE" | cut -f1)
NB_TABLES=$(grep -c '^CREATE TABLE' "$SORTIE")
NB_INSERT=$(grep -c '^INSERT INTO' "$SORTIE")
echo ""
echo "[OK] $SORTIE — $TAILLE, $NB_TABLES tables, $NB_INSERT insertions"
echo "     Ni compte, ni empreinte de mot de passe, ni message, ni navigation."
echo "     Restent les coordonnees publiques de l'etablissement, qui sont"
echo "     affichees sur le site : le fichier peut etre commit."
echo ""
echo "     git add -f $SORTIE && git commit -m \"chore: dump de deploiement\" && git push"
echo ""
echo "     Le compte d'administration n'est pas dans le dump. Apres l'import,"
echo "     le creer sur le serveur avec app:create-super-admin."
