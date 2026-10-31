#!/bin/bash
# =============================================================================
# Outil local de gestion des clients BlogWeb
#
#   ./scripts/client.sh switch bw_xxx   Passer sur un client (branche + config + cache)
#   ./scripts/client.sh update bw_xxx   Merge tactique de main, controle, push
#   ./scripts/client.sh deploy bw_xxx   Lancer deploy-ovh.sh sur le serveur du client
#
# Config par client : .env.bw_xxx.local (ignore par git), copie dans .env.local.
# Pour deploy, y ajouter : DEPLOY_SSH=user@ftp.clusterXXX.hosting.ovh.net
#                          DEPLOY_DIR=chemin du projet sur le serveur (ex. ~/bw_xxx)
# main utilise .env.main.local, base blog_web.
# =============================================================================
set -euo pipefail

# Lance depuis Git Bash Windows : git y reecrit l'arbre en CRLF. On repasse par WSL.
if [[ "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]]; then
    CHEMIN_WSL=$(pwd | sed -E 's#^//wsl(\.localhost|\$)/[^/]+##')
    MSYS_NO_PATHCONV=1 exec wsl.exe -d Ubuntu -- bash -lc "cd '$CHEMIN_WSL' && ./scripts/client.sh $*"
fi

# Changer de branche ferait disparaitre ce fichier (absent des branches pas
# encore mergees) pendant que bash le lit : on tourne depuis une copie.
if [ -z "${CLIENT_SH_RACINE:-}" ]; then
    RACINE="$(cd "$(dirname "$0")/.." && pwd)"
    COPIE=$(mktemp)
    cp "$0" "$COPIE"
    CLIENT_SH_RACINE="$RACINE" exec bash "$COPIE" "$@"
fi
cd "$CLIENT_SH_RACINE"
trap 'rm -f "$0"' EXIT

COMMANDE="${1:-}"
BRANCHE="${2:-}"

usage() {
    sed -n '3,12p' scripts/client.sh 2>/dev/null | sed 's/^# \{0,1\}//'
    exit 1
}

[ -n "$COMMANDE" ] && [ -n "$BRANCHE" ] || usage
[[ "$BRANCHE" == bw_* || "$BRANCHE" == main ]] || { echo "ERREUR: branche bw_xxx ou main attendue"; exit 1; }

ENV_CLIENT=".env.$BRANCHE.local"
BASE_ATTENDUE="$BRANCHE"
[ "$BRANCHE" = main ] && BASE_ATTENDUE="blog_web"

console() { docker compose exec -T php php bin/console "$@"; }

# Nom de la base vers laquelle pointe .env.local (ligne DATABASE_URL active)
base_courante() {
    grep -E '^DATABASE_URL' .env.local | tail -1 | sed -E 's#.*/([A-Za-z0-9_]+)\?.*#\1#'
}

verifier_arbre_propre() {
    if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
        echo "ERREUR: modifications en cours, a committer ou mettre de cote avant de changer de client."
        git status -s --untracked-files=no
        exit 1
    fi
}

switch_client() {
    verifier_arbre_propre
    if [ ! -f "$ENV_CLIENT" ]; then
        echo "ERREUR: $ENV_CLIENT absent."
        echo "        Le creer depuis un autre client en changeant le nom de base, ex. :"
        echo "        sed 's#/blog_web?#/$BASE_ATTENDUE?#' .env.main.local > $ENV_CLIENT"
        exit 1
    fi

    git checkout -q "$BRANCHE"
    git pull -q --ff-only
    cp "$ENV_CLIENT" .env.local

    # Garde-fou : jamais la base d'un autre client (cf. migrations seo_systeme sur bw_mainguy)
    if [ "$(base_courante)" != "$BASE_ATTENDUE" ]; then
        echo "ERREUR: $ENV_CLIENT pointe sur la base « $(base_courante) », pas « $BASE_ATTENDUE »."
        exit 1
    fi

    console cache:clear >/dev/null
    echo "[OK] $BRANCHE, base $BASE_ATTENDUE"
}

# Pages publiques en 200, ticket de visite sur l'accueil, aucune erreur critique nouvelle
controler_site() {
    local alertes=0 code
    local debut
    debut=$(docker compose exec -T php php -r "echo date('Y-m-d\TH:i:s');" 2>/dev/null || true)
    for chemin in / /contact /sitemap.xml /robots.txt /login; do
        code=$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:8090$chemin")
        echo "       $chemin $code"
        [ "$code" = 200 ] || alertes=$((alertes + 1))
    done
    if ! curl -s -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36' http://localhost:8090/ | grep -q 'name="bw-visit"'; then
        echo "[!] Pas de ticket de visite sur l'accueil"
        alertes=$((alertes + 1))
    fi
    if [ -n "$debut" ] && [ -f var/log/dev.log ] && grep 'request.CRITICAL' var/log/dev.log | awk -v d="[$debut" '$1 >= d' | grep -q .; then
        echo "[!] Erreur critique pendant les controles :"
        grep 'request.CRITICAL' var/log/dev.log | tail -1 | cut -c1-250
        alertes=$((alertes + 1))
    fi
    return "$alertes"
}

update_client() {
    [ "$BRANCHE" != main ] || { echo "ERREUR: update concerne une branche client"; exit 1; }
    verifier_arbre_propre

    git fetch -q origin main
    git checkout -q main && git pull -q --ff-only
    switch_client

    echo "[1/6] Merge tactique de main..."
    if ! git merge --no-edit -m "Merge main dans $BRANCHE" main; then
        echo ""
        echo "ERREUR: conflit. A resoudre a la main (les surcouches templates/client/ du"
        echo "        client priment), puis : git commit && ./scripts/client.sh update $BRANCHE"
        exit 1
    fi

    echo "[2/6] Migrations (base $BASE_ATTENDUE)..."
    console doctrine:migrations:migrate --no-interaction --allow-no-migration
    console doctrine:schema:validate

    echo "[3/6] Build des assets..."
    if ! docker compose run --rm -T -w /var/www/html node npm run build >/tmp/client-build.log 2>&1; then
        tail -20 /tmp/client-build.log
        echo "ERREUR: build des assets (journal complet : /tmp/client-build.log)"
        exit 1
    fi
    git checkout -- package-lock.json 2>/dev/null || true

    echo "[4/6] Cache et tests unitaires..."
    console cache:clear >/dev/null
    console cache:pool:clear cache.app >/dev/null
    docker compose exec -T php php vendor/bin/phpunit tests/Unit | tail -1

    echo "[5/6] Controle du site local..."
    if ! controler_site; then
        echo ""
        echo "ERREUR: le site local ne tourne pas correctement. Rien n'est pousse."
        exit 1
    fi

    echo "[6/6] Push..."
    git push -q origin "$BRANCHE"
    echo ""
    echo "[OK] $BRANCHE a jour et pousse ($(git log --oneline -1))."
    echo "     En prod : ./scripts/client.sh deploy $BRANCHE"
}

deploy_client() {
    [ -f "$ENV_CLIENT" ] || { echo "ERREUR: $ENV_CLIENT absent"; exit 1; }
    local ssh_cible dossier
    ssh_cible=$(grep -E '^DEPLOY_SSH=' "$ENV_CLIENT" | tail -1 | cut -d= -f2- | tr -d "\"' ")
    dossier=$(grep -E '^DEPLOY_DIR=' "$ENV_CLIENT" | tail -1 | cut -d= -f2- | tr -d "\"' ")
    if [ -z "$ssh_cible" ] || [ -z "$dossier" ]; then
        echo "ERREUR: ajouter DEPLOY_SSH et DEPLOY_DIR dans $ENV_CLIENT, ex. :"
        echo "        DEPLOY_SSH=ttuzcgq-bw_mainguy@ftp.cluster100.hosting.ovh.net"
        echo "        DEPLOY_DIR=~/bw_mainguy"
        exit 1
    fi
    echo "Deploy de $BRANCHE sur $ssh_cible:$dossier"
    echo "(un seul essai de mot de passe : apres 3 echecs, OVH bloque l'IP un moment)"
    ssh -t "$ssh_cible" "cd $dossier && ./scripts/deploy-ovh.sh"
}

case "$COMMANDE" in
    switch) switch_client ;;
    update) update_client ;;
    deploy) deploy_client ;;
    *) usage ;;
esac
