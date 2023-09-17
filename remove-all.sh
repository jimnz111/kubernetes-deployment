echo "Deleting all pods etc"

doRemove ./common/namespace.yaml
./microservices/remove.sh
./postgresql/remove.sh
./sftp/remove.sh
./microservices/remove.sh