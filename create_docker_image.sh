#!/bin/bash

# exit when any command fails
set -e

# Validate That Required Inputs Were Supplied
function check_env() {
    if [ -z $(eval echo "\$$1") ]; then
        echo "Variable $1 not found.  Exiting..."
        exit 1
    fi
}

check_env "INPUT_IMAGE_NAME"

# Pick username
NB_USER=${NOTEBOOK_USER:-"$GITHUB_ACTOR"}

shortSHA=$(echo "${GITHUB_SHA}" | cut -c1-12)
SHA_NAME="${INPUT_IMAGE_NAME}:${shortSHA}"

echo "Using user $NB_USER to create image name $SHA_NAME"

# Run repo2docker
cmd="jupyter-repo2docker --no-run --user-id 1234 --user-name ${NB_USER} --image-name ${SHA_NAME} --ref $GITHUB_SHA ${PWD}"
echo "repo2docker command: $cmd"
eval $cmd

echo "About to check docker path"
docker --version
echo "Finished checking docker path"

echo "About to run docker run ${SHA_NAME} /srv/conda/bin/conda --version"
CURR_CONDA_VER=`docker run $SHA_NAME /srv/conda/bin/conda --version | cut -d " " -f 2`
CURR_R2D_VER=`docker run $SHA_NAME /srv/conda/envs/notebook/bin/pip list | grep jupyter-repo2docker`

echo "Variable results = $CURR_CONDA_VER and $CURR_R2D_VER"

CURR_CONDA_VER="UNKNOWN"
CURR_R2D_VER="UNKNOWN"
CURR_DOCKER_VER=`docker --version`

# Emit output variables
echo "::set-output name=CURR_CONDA_VER::${CURR_CONDA_VER}"
echo "::set-output name=CURR_R2D_VER::${CURR_R2D_VER}"
echo "::set-output name=CURR_DOCKER_VER::${CURR_DOCKER_VER}"
