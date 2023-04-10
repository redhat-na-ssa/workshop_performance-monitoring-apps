#!/bin/sh

oc whoami
oc project

kn service create quarkus-app \
 --image=quay.io/rafaeltuelho/quarkus-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1024Mi \
 --scale=0..10 \
 --no-wait \
 --force \
 --env QUARKUS_LOG_CATEGORY__ORG_HIBERNATE__LEVEL=INFO \
 --env QUARKUS_HIBERNATE-ORM_LOG_SQL=false

 kn service create micronaut-app \
 --image=quay.io/rafaeltuelho/micronaut-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1024Mi \
 --scale=0..10 \
 --no-wait \
 --force

 kn service create springboot-app \
 --image=quay.io/rafaeltuelho/springboot-app:latest \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=1000m,memory=1024Mi \
 --scale=0..10 \
 --no-wait \
 --force \
 --env spring_profiles_active=production