SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/_common_utils.sh

echo "Creating all pods etc"
doApply ./common/namespace.yaml
./postgresql/create.sh
./sftp/create.sh
./microservice/create.sh
