#!/bin/bash
clear
if [ $# -ne 2 ]; then
  echo "Wrong # of args. Expected 'metric' and 'target' args."
  exit 1
fi

METRIC=$1
TARGET=$2
PS3="Select the application to enable auto-scaling: "
declare -a apps=("quarkus-app" "micronaut-app" "springboot-app")
select opt in ${apps[@]}
do
  case $opt in

    "quarkus-app" | "micronaut-app" | "springboot-app")

      #rollback other svcs to original scaling conf
      otherApps=(${apps[@]/*${app}*/})
      for svc in ${otherApps[@]}; do
        kn service update ${svc} -n "$(oc whoami)-staging" \
          --annotation autoscaling.knative.dev/class=kpa.autoscaling.knative.dev \
          --scale-metric concurrency \
          --scale-target=100 \
          --no-wait
      done
      echo
      echo "enabling $METRIC based scaling with $TARGET as the threashould value..."
      echo
      kn service update ${opt:-quarkus-app} -n "$(oc whoami)-staging" \
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