#!/bin/bash

set -e

# Build Swift executable
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    --volume "$(pwd)/.build/native/Packages:/app/Packages" \
    lambda-ubuntu \
    swift build -c release --build-path .build/native
mkdir -p .build/lambda
cp .build/native/release/Lambda .build/lambda/

# Copy libraries necessary to run Swift executable
mkdir -p .build/lambda/libraries
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    lambda-ubuntu \
    /bin/bash -c "ldd .build/native/release/Lambda | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | xargs -i% cp % .build/lambda/libraries"

# Run integration tests
cp Shim/index.js .build/lambda/
docker build \
    -t lambda-amazonlinux \
    -f Dockerfile-amazonlinux \
    .
docker run --rm -v "$(pwd):/app" -w /app/.build/lambda lambda-amazonlinux node -e 'var fs = require("fs");require("./").handler(JSON.parse(fs.readFileSync("../../session_start.json", "utf8")), {}, function(e, r) {if (e) {console.error(e);process.exit(1);} else {console.log(r);}});'

# Zip Swift executable, libraries and Node.js shim
cd .build/lambda
rm -f lambda.zip
zip -r lambda.zip *
cd ../..