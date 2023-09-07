#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh

addSubstitution "{{namespace}}" "sftp"

# doRemove "${SCRIPT_DIR}/sftp-deployment.yaml"
# runCommand "kubectl delete secret \
#   --namespace $(getKey "{{namespace}}") \
#   sftp-ssh-secrets"
 
doRemove "${SCRIPT_DIR}/sftp-namespace.yaml"
