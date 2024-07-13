#!/bin/sh

# Bei einem Fehler Skript abbrechen
set -e

# Warten auf die Datenbank
python manage.py wait_for_db

# Stellt Static-Files in einem Verzeichnis bereit
# Keine Routing durch Django notwendig
# Für Erreichbarkeit durch Proxy
python manage.py collectstatic --noinput

# Alle offenen Migrations ausführen
python manage.py migrate

# socket :9000 - Port 9000 verwenden
# workers 4 - 4 Anfragen gleichzeitig
# master - uwsgi ist im Master-Modus
#          kann alles überwachen und
#          neustarten
# enable-threads - Mehrere Threads in
#                  einem Worker möglich
# module - App mit der WSGI-Anwendung
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi
