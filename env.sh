#!/bin/bash
set -e

GIT_HASH=$(git rev-parse --short HEAD)
export GIT_HASH

VISIO_BACKEND_IMAGE="128958473299.dkr.ecr.us-east-2.amazonaws.com/visio_backend"
export VISIO_BACKEND_IMAGE

VISIO_AWS_PROFILE='--profile visio-eng'
export VISIO_AWS_PROFILE