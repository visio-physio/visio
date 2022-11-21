#!/bin/bash
set -e
. ../env.sh

IMAGE_NAME="$VISIO_BACKEND_IMAGE"

echo 'Logging into AWS ECR'
$(aws ecr get-login-password --no-include-email --region us-east-2 $VISIO_AWS_PROFILE)

./build.sh

echo "Pushing image $IMAGE_NAME"
docker push "$IMAGE_NAME" 
echo 'Image pushed!'
