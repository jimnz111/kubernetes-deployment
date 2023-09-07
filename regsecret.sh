#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/_common_utils.sh
echo "Secret creation"

#addSubstitution "{{namespace}}" "sftp"

doApply "${SCRIPT_DIR}/secret.registry.yaml"

