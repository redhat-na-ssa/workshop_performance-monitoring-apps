#!/bin/bash

OPERATOR_API_GROUP="postgres-operator.crunchydata.com"
POSTGRES_INSTANCE_NAME="postgres"
oc project ${DEVWORKSPACE_NAMESPACE}

echo
echo "Check if the Crunchydata Postgres Operator is present."
oc api-resources --api-group=$OPERATOR_API_GROUP
if [[ $? -gt 0 ]] 
then
   echo
   echo "No Postgres Operator present in this cluster!!!"
   exit 1
fi

echo
echo "Check if there is PG Cluster already deployed."
oc get PostgresCluster $POSTGRES_INSTANCE_NAME
if [[ $? -eq 0 ]] 
then
   echo
   echo "Resource $POSTGRES_INSTANCE_NAME already present in this project!!!"
   exit 1
fi

echo
echo "Creating db initialization script as a ConfigMap"
oc create -f ${PROJECT_SOURCE:-$(pwd)}/infrastructure/db-init/db-init-cm.yaml
echo
echo "Creating a PostgreSQL instance using ${OPERATOR_API_GROUP}..."
oc create -f ${PROJECT_SOURCE:-$(pwd)}/infrastructure/postgresdb-cr.yaml
if [[ $? -eq 0 ]] 
then
  echo
  echo "Wait until PG instance gets ready..."
  sleep 3
  podname=$(oc get pod -o name | grep pod/$POSTGRES_INSTANCE_NAME-instance1)
  oc wait --timeout=120s --for=condition=Ready $podname

  # Annotate PG cluster resources to group them
  oc label statefulsets \
    -l postgres-operator.crunchydata.com/cluster=$POSTGRES_INSTANCE_NAME app.kubernetes.io/part-of=Postgres-Cluster
  oc label jobs \
    -l postgres-operator.crunchydata.com/cluster=$POSTGRES_INSTANCE_NAME app.kubernetes.io/part-of=Postgres-Cluster

  # change the auto-generated SCRAM based db password
  oc patch secret $POSTGRES_INSTANCE_NAME-pguser-$POSTGRES_INSTANCE_NAME \
    -p '{"stringData":{"password":"password","verifier":""}}'

  echo "then you can connect to it using the following properties:"
  echo

#   oc get secret postgres-pguser-postgres -o json | jq '{ 
#       user: .data.user | @base64d, 
#       password: .data.password | @base64d, 
#       host: .data.host | @base64d, 
#       dbname: .data.dbname | @base64d, 
#       uri: .data.uri | @base64d
#       }' > ${PROJECT_SOURCE:-$(pwd)}/pg-conn-info.json

  oc get secret $POSTGRES_INSTANCE_NAME-pguser-$POSTGRES_INSTANCE_NAME -o json | jq "{ 
      user: .data.user | @base64d, 
      password: .data.password | @base64d, 
      host: \"$POSTGRES_INSTANCE_NAME-ha\",
      dbname: .data.dbname | @base64d, 
      uri:  \"jdbc:postgresql://$POSTGRES_INSTANCE_NAME-ha/postgres\" 
      }" > ${PROJECT_SOURCE:-$(pwd)}/pg-conn-info.json

  cat ${PROJECT_SOURCE:-$(pwd)}/pg-conn-info.json
   # sample output
   # {
   #   "user": "postgres",
   #   "password": "secret",
   #   "host": "postgres-primary.sandbox.svc",
   #   "dbname": "postgres",
   #   "uri": "postgresql://postgres@postgres-primary.sandbox.svc:5432/postgres",
   #   "verifier": ""
   # }
else
   echo
   echo "unable to create the cluster!!!"
fi