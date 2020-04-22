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

# Run repo2docker
cmd="jupyter-repo2docker --no-run --user-id 1234 --user-name ${NB_USER} --image-name ${SHA_NAME} --ref $GITHUB_SHA ${PWD}"
echo "repo2docker command: $cmd"
eval $cmd

CURR_CONDA_VER=`conda --version | cut -d " " -f 2`
CURR_R2D_VER=`pip list | grep jupyter-repo2docker`

# Emit output variables
echo "::set-output name=CURR_CONDA_VER::${CURR_CONDA_VER}"
echo "::set-output name=CURR_R2D_VER::${CURR_R2D_VER}"
