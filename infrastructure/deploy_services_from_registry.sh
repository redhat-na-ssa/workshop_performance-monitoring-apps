#!/bin/sh

oc whoami
oc project

kn service create quarkus-app \
 --image=quay.io/rafaeltuelho/quarkus-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --env=QUARKUS_LOG_CONSOLE_JSON=true \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --scale=0..10 \
 --no-wait \
 --force
 
 kn service create micronaut-app \
 --image=quay.io/rafaeltuelho/micronaut-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --env=JAVA_OPTS_APPEND=-Dlogback.configurationFile=logback-json.xml \
 --env=JAVA_MAX_MEM_RATIO=85.0 \
 --env=GC_MAX_HEAP_FREE_RATIO=50 \
 --scale=0..10 \
 --no-wait \
 --force

 kn service create springboot-app \
 --image=quay.io/rafaeltuelho/springboot-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1.5Gi \
 --env=spring_profiles_active=production,json-logging \
 --env=JAVA_MAX_MEM_RATIO=85.0 \
 --env=GC_MAX_HEAP_FREE_RATIO=50 \
 --scale=0..10 \
 --no-wait \
 --force
