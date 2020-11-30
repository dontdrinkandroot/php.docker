#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# docker build -t dontdrinkandroot/php:$BRANCH.common -f common.Dockerfile .
docker push dontdrinkandroot/php:$BRANCH.common
