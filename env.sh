#!/bin/bash
set -e

GIT_HASH=$(git rev-parse --short HEAD)
export GIT_HASH

BACKEND_ECR_REPO="128958473299.dkr.ecr.us-east-2.amazonaws.com/visio_backend"
export BACKEND_ECR_REPO
BACKEND_BUILD_IMAGE_NAME="$BACKEND_ECR_REPO:$GIT_HASH"
export BACKEND_BUILD_IMAGE_NAME