#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh

addSubstitution "{{namespace}}" "postgres"

doApply "${SCRIPT_DIR}/postgres-namespace.yaml"
doApply "${SCRIPT_DIR}/postgres-storage.yaml"
doApply "${SCRIPT_DIR}/postgres-configmap.yaml"
runCommand "kubectl create configmap ddl-scripts \
    --namespace $(getKey "{{namespace}}") \
    --from-file=init-scripts/create-1.sql \
    --from-file=init-scripts/data-2.sql"
doApply "${SCRIPT_DIR}/postgres-deployment.yaml"
doApply "${SCRIPT_DIR}/postgres-service.yaml"
