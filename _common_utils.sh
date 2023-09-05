# My Var Substitutions

export SUBSTITUTIONS=()


CURDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TEMPDIR="${CURDIR}/.tmp"
if [[ -d ${TEMPDIR} ]]; then
  rm -rf ${TEMPDIR}
fi
mkdir -p ${TEMPDIR}

# Iterate through the array to find the value of the key
function getKey() {
    for ((i = 0; i < ${#SUBSTITUTIONS[@]}; i++)); do
        local key_value="${SUBSTITUTIONS[$i]}"
        local key="${key_value%%=*}"   # Extract the part before the colon
        local value="${key_value#*=}"      # Extract the part after the colon
        if [[ "$key" == "${1}" ]]; then
            echo ${value}
            break
        fi
    done 
}

# $1 = key to search for
# $2 = substitution value
function addSubstitution() {
    echo "Adding substitution [${1}]=[${2}]"

    # Iterate through the array to find and replace the key
    for ((i = 0; i < ${#SUBSTITUTIONS[@]}; i++)); do
        local key_value="${SUBSTITUTIONS[$i]}"
        local key="${key_value%%=*}"   # Extract the part before the colon
        local value="${key_value#*=}"      # Extract the part after the colon
        if [[ "$key" == "${1}" ]]; then
            echo "Replacing value [${value}] with [${2}]"
            SUBSTITUTIONS[$i]="$key=${2}"
            found="Y"
            break
        fi
    done

    if [[ -z ${found} ]]; then 
        SUBSTITUTIONS+=("${1}=${2}")
    fi
}

while IFS='=' read -r key value; do
  addSubstitution ${key} ${value}
done < ${CURDIR}/defaults.txt


function runCommand() {
    local cmd=$@
    echo "Running [${cmd}]"
    ${cmd}
    RC=$?
    if (( ${RC} != 0 )); then
        echo "Command failed"
        exit 99
    fi
}

function replaceVars() {
    local destFile=$1
    local fullfile=$2
    local tempfile="${TEMPDIR}/$(basename ${fullfile})"
    echo "Copying [${fullfile}] to [${tempfile}]"
    cp ${fullfile} ${tempfile}
    for i in "${SUBSTITUTIONS[@]}"
    do
        local key="${i%%=*}"   # Extract the part before the colon
        local value="${i#*=}"  # Extract the part after the colon
        echo "substituting [${key}] with [${value}]"
        sed -i -r "s/${key}/${value}/g" ${tempfile}
    done

    eval "${destFile}=${tempfile}"
}

function runFile() {
    local kubeCommand=$1
    local file=$2
    local newFile 
    replaceVars "newFile" ${file}
    runCommand "kubectl ${kubeCommand} -f ${newFile}"
}

function doApply() {
    runFile "apply" $@
}

function doRemove() {
    runFile "delete" $@
}