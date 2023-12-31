#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../_common_utils.sh
echo "SFTP creation"

#addSubstitution "{{namespace}}" "sftp"
#doApply "${SCRIPT_DIR}/sftp-namespace.yaml"

keyfile="${TEMPDIR}/ssh_host_ed25519_key"
ssh-keygen -t ed25519 -N test -f ${keyfile}

runCommand "kubectl create secret generic sftp-ssh-secrets \
  --namespace $(getKey "{{namespace}}") \
  --from-file=ssh-privatekey=${keyfile} \
  --from-file=ssh-publickey=${keyfile}.pub"

doApply "${SCRIPT_DIR}/../secret.registry.yaml"

doApply "${SCRIPT_DIR}/sftp-deployment.yaml"
