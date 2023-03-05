#!/bin/bash
set -e
. ../env.sh

IMAGE_NAME="$VISIO_BACKEND_IMAGE"

echo "Building image $IMAGE_NAME"
docker build . -t "$IMAGE_NAME"