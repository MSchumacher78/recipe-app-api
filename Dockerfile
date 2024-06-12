#Base Image
FROM python:3.9-alpine3.13

#Maintainer
LABEL maintainer="TEST"

#Direct Output from Python to the Screen / No Buffering
ENV PYTHONUNBUFFERED 1

#Copy neccessary project-files into the Container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

#Define starting directory
WORKDIR /app

#Set Port
EXPOSE 8000

# Will be overwritten by Docker Compose
# If in Development Environment then install dev-requirements too
ARG DEV=false

#Pipe commands to prevent creating Layer for every single command
# Oneline if Statement if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt ; fi && \
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        -- django-user

ENV PATH="/py/bin:$PATH"

#For security reasons - dont use the rootaccess
USER django-user