#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/_common_utils.sh
echo "Secret creation"

addSubstitution "{{namespace}}" "sftp"

doApply "${SCRIPT_DIR}/secret.registry.yaml"

# kubectl create secret \
#   docker-registry p1cc-registry \
# --docker-server=p1cc-docker-dev.docker.fis \
# --docker-username=e1069023 \
# --docker-password=AKCp8nzBjWK696KZMdpjkPzL9w8s12DPoWxremkfWs74PXBB64tm7mTmnsYHQ7gC3zSBx2GZr \
# --docker-email=james.bushell@fisglobal.com
