#!/bin/sh

clear
echo
read -e -p "Enter a project namespaces as the deployment target (Enter to accept default value): " -i "$(oc whoami)-staging" NAMESPACE
[[ -z $NAMESPACE ]] && echo "Project namespace required" && exit 1

oc whoami
# oc project $NAMESPACE

kn service create quarkus-app \
 --image=quay.io/redhat_na_ssa/quarkus-app:latest \
 --probe-liveness='http:::/q/health/live' \
 --probe-liveness-opts='initialDelaySeconds=3,periodSeconds=30,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --probe-readiness='http:::/q/health/ready' \
 --probe-readiness-opts='initialDelaySeconds=3,periodSeconds=10,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=2,memory=1.5Gi \
 --env=JAVA_MAX_MEM_RATIO=75.0 \
 --env=GC_MAX_HEAP_FREE_RATIO=25 \
 --label=app.openshift.io/runtime=quarkus \
 --scale=0..3 \
 --no-wait \
 -n $NAMESPACE \
 --force
# use when # of cpu >= 2 and heap mem <=4gb
# --env=GC_CONTAINER_OPTIONS='-XX:+UseSerialGC' \
# --env=GC_CONTAINER_OPTIONS=-XX:+UseParallelGC \
        # - name: GC_CONTAINER_OPTIONS
        #   value: -XX:+UseSerialGC
        # - name: JAVA_MAX_MEM_RATIO
        #   value: "75"
        # - name: JAVA_OPTS_APPEND
        #   value: "-XX:ActiveProcessorCount=2"

 kn service create micronaut-app \
 --image=quay.io/redhat_na_ssa/micronaut-app:latest \
 --probe-liveness='http:::/health' \
 --probe-liveness-opts='initialDelaySeconds=3,periodSeconds=30,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --probe-readiness='http:::/health' \
 --probe-readiness-opts='initialDelaySeconds=3,periodSeconds=15,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=2,memory=1.5Gi \
 --env=JAVA_MAX_MEM_RATIO=75.0 \
 --env=GC_MAX_HEAP_FREE_RATIO=25 \
 --label=app.openshift.io/runtime=java \
 --scale=0..3 \
 --no-wait \
 -n $NAMESPACE \
 --force

 kn service create springboot-app \
 --image=quay.io/redhat_na_ssa/springboot-app:latest \
 --probe-liveness='http:::/actuator/health/liveness' \
 --probe-liveness-opts='initialDelaySeconds=7,periodSeconds=30,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --probe-readiness='http:::/actuator/health/readiness' \
 --probe-readiness-opts='initialDelaySeconds=7,periodSeconds=30,failureThreshold=3,successThreshold=1,timeoutSeconds=10' \
 --request=cpu=200m,memory=128Mi \
 --limit=cpu=2,memory=1.5Gi \
 --env=JAVA_MAX_MEM_RATIO=75.0 \
 --env=GC_MAX_HEAP_FREE_RATIO=25 \
 --env=SPRING_PROFILES_ACTIVE=production \
 --label=app.openshift.io/runtime=spring-boot \
 --scale=0..3 \
 --no-wait \
 -n $NAMESPACE \
 --force
