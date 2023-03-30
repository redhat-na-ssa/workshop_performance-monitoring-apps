#!/bin/bash

OPERATOR_API_GROUP="postgres-operator.crunchydata.com"
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
oc get PostgresCluster postgres
if [[ $? -eq 0 ]] 
then
   echo
   echo "Resource pg-cluster already present in this project!!!"
   exit 1
fi

echo
echo "Create a PostgreSQL instance using ${OPERATOR_API_GROUP}..."
oc create -f ${PROJECT_SOURCE:-$(pwd)}/infrastructure/postgresdb-cr.yaml
if [[ $? -eq 0 ]] 
then
  echo
  echo "Wait until PG instance gets ready..."
  sleep 3
  podname=$(oc get pod -o name | grep pod/postgres-instance1)
  oc wait --for=condition=Ready $podname
  echo "then you can connect to it using the following properties:"
  echo

  oc get secret postgres-pguser-postgres -o json | ./infrastructure/jq '{ 
      user: .data.user | @base64d, 
      password: .data.password | @base64d, 
      host: .data.host | @base64d, 
      dbname: .data.dbname | @base64d, 
      uri: .data.uri | @base64d
      }' > ${PROJECT_SOURCE:-$(pwd)}/pg-conn-info.json

  cat ${PROJECT_SOURCE:-$(pwd)}/pg-conn-info.json
   # sample output
   # {
   #   "user": "postgres",
   #   "password": "@a)y?jK2hO/(FblaJ@,hwv0J",
   #   "host": "postgres-primary.sandbox.svc",
   #   "dbname": "postgres",
   #   "uri": "postgresql://postgres:%40a%29y%3FjK2hO%2F%28FblaJ%40,hwv0J@postgres-primary.sandbox.svc:5432/postgres",
   #   "verifier": "SCRAM-SHA-256$4096:dx/lre7Yh5vKxV7ognryUg==$wypAIBxmEgAzPCqi94O7ME3+0+tqLlPh+6h8TN1Q8GM=:2iY6d1RYEtyMU60Y5IZp1wXGhwkhGHj6RYQ25gWBrDc="
   # }
else
   echo
   echo "unable to create the cluster!!!"
fi