# Basis-Image für den Container
FROM python:3.9-alpine3.13

# Wer ist für die Wartung zuständig
LABEL maintainer="TEST"

# Direkte Ausgabe auf dem Bildschirm
# Keine Pufferung
ENV PYTHONUNBUFFERED 1

# Alle Dateien in den Container kopieren
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app

# Start-Verzeichnis festlegen
WORKDIR /app

# Port Festlegen
EXPOSE 8000

# Kann von Docker Compose überschrieben werden
# Installiere im Entwicklungsmodus auch die Dev-Abhängigkeiten
ARG DEV=false

# Hänge die Befehle aneinander - So wird nur eine neue Ebene im Docker-Container erstellt
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

# Pfad zur virtuellen Umgebung hinzufügen
ENV PATH="/scripts:/py/bin:$PATH"

# Den Django-User verwenden
USER django-user

# Den Default-Skript verwenden für uWSGI-Produktions-Server
CMD ["run.sh"]