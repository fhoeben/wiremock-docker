#!/usr/bin/env bash

set -e

VERSION=$1

docker build --pull . -t wiremock:latest --build-arg WIREMOCK_VERSION=${VERSION}

#docker run --name wiremock-test wiremock:latest
#docker rm -f wiremock-test

docker tag wiremock:latest hsac/wiremock:latest
docker tag wiremock:latest hsac/wiremock:${VERSION}

docker push hsac/wiremock:latest
docker push hsac/wiremock:${VERSION}
