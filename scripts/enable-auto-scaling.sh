#!/bin/bash
clear
if [ $# -ne 2 ]; then
  echo "Wrong # of args. Expected 'metric' and 'target' args."
  exit 1
fi

OCP_USER=$(oc whoami)
METRIC=$1
TARGET=$2
PS3="Select the application to enable auto-scaling: "
declare -a apps=("quarkus-app" "micronaut-app" "springboot-app")
select opt in ${apps[@]}
do
  case $opt in

    "quarkus-app" | "micronaut-app" | "springboot-app")

      #rollback other svcs to original scaling conf
      otherApps=(${apps[@]/*${opt}*/})
      for svc in ${otherApps[@]}; do
        scalingClass=$(oc get ksvc $svc --ignore-not-found=true -n $OCP_USER-staging -o jsonpath="{.spec.template.metadata.annotations['autoscaling\.knative\.dev\/class']}")
        # echo "$svc scaling class: [$scalingClass]"
        if [[ ! -z $scalingClass && $scalingClass == *"hpa"* ]]
        then
          echo "switching $svc back to KPA scaling class..."
          kn service update ${svc} -n "$OCP_USER-staging" \
            --annotation autoscaling.knative.dev/class=kpa.autoscaling.knative.dev \
            --scale-metric concurrency \
            --scale-target=10
            # --no-wait
        fi
      done
      echo
      echo "enabling $METRIC based scaling with $TARGET as the threashould value..."
      echo
      kn service update ${opt:-quarkus-app} -n "$OCP_USER-staging" \
        --annotation autoscaling.knative.dev/class=hpa.autoscaling.knative.dev \
        --scale-metric ${METRIC:-cpu} \
        --scale-target=${TARGET:-20}
      break
      ;;

    *)
      echo "Invalid option $REPLY"
      ;;
    esac

done