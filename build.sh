#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker build --pull -t dontdrinkandroot/php:build-$BRANCH -f build/Dockerfile build/ \
&& docker build -t dontdrinkandroot/php:symfony-base-$BRANCH -f symfony/base.Dockerfile symfony/ \
&& docker build -t dontdrinkandroot/php:symfony-dev-$BRANCH -f symfony/dev.Dockerfile --build-arg FROM=dontdrinkandroot/php:symfony-base-$BRANCH symfony/ \
&& docker build -t dontdrinkandroot/php:symfony-prod-$BRANCH -f symfony/prod.Dockerfile --build-arg FROM=dontdrinkandroot/php:symfony-base-$BRANCH symfony/
