#!/bin/bash
set -e

export GIT_HASH=$(git rev-parse --short HEAD)

export VISIO_BACKEND_IMAGE="128958473299.dkr.ecr.us-east-2.amazonaws.com/visio_backend"

export VISIO_AWS_PROFILE='--profile visio-eng'