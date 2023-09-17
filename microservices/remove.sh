!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh

#addSubstitution "{{namespace}}" "postgres"
kubectl delete configmap \
  --namespace $(getKey "{{namespace}}") \
  app-one-config

doRemove "${SCRIPT_DIR}/app-one/configmap.yaml"
doRemove "${SCRIPT_DIR}/app-one/deployment.yaml"
