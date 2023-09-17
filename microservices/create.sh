#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh
echo "Microservices creation"

### To build the image for minikube ensure you run "eval `minikube docker env`" first!

#### DOMAIN 1
runCommand "kubectl create configmap app-one-config \
    --namespace $(getKey "{{namespace}}") \
    --from-file=${SCRIPT_DIR}/app-one/config/application.properties"

doApply "${SCRIPT_DIR}/app-one/configmap.yaml"
doApply "${SCRIPT_DIR}/app-one/deployment.yaml"
