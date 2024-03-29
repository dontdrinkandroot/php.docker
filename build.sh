#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker build --pull -t dontdrinkandroot/php:$BRANCH-common -f common.Dockerfile . \
&& docker build -t dontdrinkandroot/php:$BRANCH-test -f test.Dockerfile --build-arg FROM=dontdrinkandroot/php:$BRANCH-common . \
&& docker build -t dontdrinkandroot/php:$BRANCH-symfony-dev -f symfony-dev.Dockerfile --build-arg FROM=dontdrinkandroot/php:$BRANCH-test . \
&& docker build -t dontdrinkandroot/php:$BRANCH-symfony-prod -f symfony-prod.Dockerfile --build-arg FROM=dontdrinkandroot/php:$BRANCH-common .
