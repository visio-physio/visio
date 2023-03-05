#!/bin/bash
set -e
. ../env.sh

IMAGE_NAME="$VISIO_BACKEND_IMAGE"

echo 'Logging into AWS ECR'
$(aws ecr get-login-password --region us-east-2 $VISIO_AWS_PROFILE | docker login --username AWS --password-stdin $VISIO_BACKEND_IMAGE)

./build.sh

echo "Pushing image $IMAGE_NAME"
docker push "$IMAGE_NAME" 
echo 'Image pushed!'
