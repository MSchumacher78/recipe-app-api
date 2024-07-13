#!/bin/bash

APP_NAME="Rezept API"
VERSION="0.1"

function start {
    echo "App wird gestartet..."
    docker compose up
}

function stop {
    echo "App wird gestoppt..."
    docker compose down
}

function test {
    echo "App wird getestet..."
    docker compose run --rm app sh -c "python manage.py test"
}

function lint {
    echo "App in Entwicklung wird geprüft..."
    docker compose run --rm app sh -c "flake8"
}

function make {
    echo "App-Migrationen werden erstellt..."
    docker compose run --rm app sh -c "python manage.py makemigrations"
}

function rebuild {
    echo "App wird neu gebaut..."
    docker compose build --no-cache
}

function help {
    echo "Verfügbare Kommandos:"
    echo "start     - Docker Container starten"
    echo "stop      - Docker Container stoppen"
    echo "test      - Docker Container testen"
    echo "lint      - Docker Container Linting"
    echo "make      - Docker Container MakeMigration"
    echo "rebuild   - Docker Container neu bauen"
    echo "help      - Diese Hilfe anzeigen"
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    test)
        test
        ;;
    lint)
        lint
        ;;
    make)
        make
        ;;
    rebuild)
        rebuild
        ;;
    help)
        help
        ;;
    *)
        echo "$APP_NAME Version $VERSION"
        echo "Für verfügbare Kommandos geben Sie '/$(basename $0) help' ein"
        ;;
esac
