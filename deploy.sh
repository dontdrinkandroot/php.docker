#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker push dontdrinkandroot/php:build-$BRANCH \
&& docker push dontdrinkandroot/php:symfony-base-$BRANCH \
&& docker push dontdrinkandroot/php:symfony-dev-$BRANCH \
&& docker push dontdrinkandroot/php:symfony-prod-$BRANCH
