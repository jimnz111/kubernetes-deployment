#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh

addSubstitution "{{namespace}}" "postgres"

doRemove "${SCRIPT_DIR}/postgres-namespace.yaml"
doRemove "${SCRIPT_DIR}/postgres-storage.yaml"
doRemove "${SCRIPT_DIR}/postgres-configmap.yaml"
runCommand "kubectl delete configmap --namespace $(getKey "{{namespace}}") ddl-scripts"
doRemove "${SCRIPT_DIR}/postgres-deployment.yaml"
doRemove "${SCRIPT_DIR}/postgres-service.yaml"
