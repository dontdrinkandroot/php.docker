#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker build -t dontdrinkandroot/php/$BRANCH/common:latest -f common.Dockerfile . \
&& docker build -t dontdrinkandroot/php/$BRANCH/test:latest -f test.Dockerfile --build-arg FROM=dontdrinkandroot/php/$BRANCH/common:latest . \
&& docker build -t dontdrinkandroot/php/$BRANCH/dev:latest -f dev.Dockerfile --build-arg FROM=dontdrinkandroot/php/$BRANCH/test:latest .
