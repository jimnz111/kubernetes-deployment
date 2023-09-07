#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/_common_utils.sh
echo "Testing creation"

echo ${SUBSTITUTIONS[@]}