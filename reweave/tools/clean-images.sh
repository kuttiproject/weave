#!/bin/sh
set -e

# These variables are used to tag the images. Change as 
# required.
: "${IMAGE_VERSION:=}"
: "${REGISTRY_USER:=}"

if [ -z "${IMAGE_VERSION}" ] || [ -z "${REGISTRY_USER}" ] ; then
    >&2 echo "Please provide valid values for IMAGE_VERSION and REGISTRY_USER." 
    exit 1
fi

# These are the names of the images
WEAVEKUBE_IMAGE=${REGISTRY_USER}/weave-kube:${IMAGE_VERSION}
WEAVENPC_IMAGE=${REGISTRY_USER}/weave-npc:${IMAGE_VERSION}

docker image rm "${WEAVEKUBE_IMAGE}" "${WEAVENPC_IMAGE}"