#!/bin/sh

# Bricht bei einem Fehler alles ab
set -e

# Liest die Umgebungsvariablen und ersetzt
# die Variablen in der default.conf.tpl und
# speichert die Daten in der default.conf
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# Startet Nginx als Hintergrundservice
nginx -g 'daemon off;'