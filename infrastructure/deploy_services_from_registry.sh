#!/bin/sh

oc whoami
oc project

kn service create quarkus-app \
 --image=quay.io/rafaeltuelho/quarkus-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --scale=0..10 \
 --no-wait \
 --force \
 --env=QUARKUS_LOG_CONSOLE_JSON=true
 
 kn service create micronaut-app \
 --image=quay.io/rafaeltuelho/micronaut-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --scale=0..10 \
 --no-wait \
 --force \
 --env=JAVA_OPTS_APPEND=-Dlogback.configurationFile=logback-json.xml

 kn service create springboot-app \
 --image=quay.io/rafaeltuelho/springboot-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --scale=0..10 \
 --no-wait \
 --force \
 --env=spring_profiles_active=production,json-logging