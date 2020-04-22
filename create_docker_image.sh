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

# Emit output variables
echo "::set-output name=IMAGE_SHA_NAME::${SHA_NAME}"
