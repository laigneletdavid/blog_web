#!/bin/bash
# Seule tache planifiee du site, a declarer une fois dans OVH :
#   Hebergement > Taches planifiees - Cron > Ajouter une planification
#   Commande : <dossier du site>/scripts/cron.sh   Langage : Autre
#   Frequence : une fois par semaine (lundi 7 h)
# Les taches elles-memes sont dans app:cron (src/Command/CronCommand.php).

cd "$(dirname "$0")/.." || exit 1

# /tmp d'OVH partage entre clients, souvent plein
export TMPDIR="$PWD/var/tmp"
mkdir -p "$TMPDIR"

# Le « php » du PATH OVH est le binaire CGI : le CLI par son chemin
PHP="${PHP_BIN:-/usr/local/php8.4/bin/php}"
[ -x "$PHP" ] || PHP=php

exec "$PHP" bin/console app:cron --env=prod --no-interaction
