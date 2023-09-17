# My Var Substitutions

export SUBSTITUTIONS=()

# shopt -s expand_aliases
# if [[ -f ~/.bash_aliases ]]; then
#     source ~/.bash_aliases
# fi


CURDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TEMPDIR="${CURDIR}/.tmp"
if [[ -d ${TEMPDIR} ]]; then
  rm -rf ${TEMPDIR}
fi
mkdir -p ${TEMPDIR}

################ALL CALLLING CODE AT THE BOTTOM AFTER THE FUNCTIONS

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
        local value="${key_value#*=}"  # Extract the part after the colon
        if [[ "$key" == "${1}" ]]; then
            echo "  - Replacing value [${value}] with [${2}]"
            SUBSTITUTIONS[$i]="${key}=${2}"
            found="Y"
        else
            found=
        fi
    done
    if [[ -z ${found} ]]; then 
        SUBSTITUTIONS+=("${1}=${2}")
    fi
}

function readSubstitutionFile() {
    local fileToRead="${1}"
    if [[ -f ${fileToRead} ]]; then
        echo "Adding environment configs from [${fileToRead}]"
        while IFS=':' read -r key value; do
            addSubstitution ${key} ${value}
        done < ${fileToRead}
    else
        echo "Skipped reading substitution file [${fileToRead}] as it does not exist"
    fi
}


function runCommand() {
    local cmd="$@"
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
        sed -i -e "s/${key}/${value}/g" ${tempfile}
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

# Used to do a kubectl apply command
function doApply() {
    runFile "apply" $@
}

# Used to do a kubectl delete command
function doRemove() {
    runFile "delete" $@
}


if ! command -v kubectl > /dev/null 2>&1; then
    echo "There is no kubectl command available. If it is an alias to minikube etc you need to create it in your ~/bin/ directory"
    echo "eg echo "minikube kubectl -- $@" > ~/bin/kubectl && chmod +x ~/bin/kubectl"
    exit 99
fi


readSubstitutionFile ${CURDIR}/defaults.txt
readSubstitutionFile ${CURDIR}/.envconfig

