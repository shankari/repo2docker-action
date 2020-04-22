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

# Pick username
NB_USER=${NOTEBOOK_USER:-"$GITHUB_ACTOR"}
IMG_NAME=${IMAGE_NAME:-"mobilitynet"}
echo "Using user $NB_USER to create image name $IMG_NAME"

# Run repo2docker
cmd="jupyter-repo2docker --no-run --user-id 1234 --user-name ${NB_USER} --image-name ${IMG_NAME} --ref $GITHUB_SHA ${PWD}"
echo "repo2docker command: $cmd"
eval $cmd

echo "About to check docker path"
docker --version
echo "Finished checking docker path"


# CURR_CONDA_VER=`/srv/conda/bin/conda --version | cut -d " " -f 2`
# CURR_R2D_VER=`/srv/conda/envs/notebook/bin/pip list | grep jupyter-repo2docker`

CURR_CONDA_VER="UNKNOWN"
CURR_R2D_VER="UNKNOWN"
CURR_DOCKER_VER=`docker --version`

# Emit output variables
echo "::set-output name=CURR_CONDA_VER::${CURR_CONDA_VER}"
echo "::set-output name=CURR_R2D_VER::${CURR_R2D_VER}"
