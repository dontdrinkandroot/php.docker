#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker build --progress=plain --pull -t dontdrinkandroot/php:build-$BRANCH -f build/Dockerfile build/ \
&& docker build --progress=plain -t dontdrinkandroot/php:symfony-base-$BRANCH -f symfony/base.Dockerfile symfony/ \
&& docker build --progress=plain -t dontdrinkandroot/php:symfony-dev-$BRANCH -f symfony/dev.Dockerfile --build-arg FROM=dontdrinkandroot/php:symfony-base-$BRANCH symfony/ \
&& docker build --progress=plain -t dontdrinkandroot/php:symfony-prod-$BRANCH -f symfony/prod.Dockerfile --build-arg FROM=dontdrinkandroot/php:symfony-base-$BRANCH symfony/
