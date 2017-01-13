#!/bin/bash

set -e

# Run unit tests
docker build \
    -t lambda-ubuntu \
    -f Dockerfile \
    .
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --volume "$(pwd)/.build/native/Packages:/app/Packages" \
    --workdir /app \
    lambda-ubuntu \
    swift test --build-path .build/native