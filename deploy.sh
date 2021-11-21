#!/bin/sh
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

docker push dontdrinkandroot/php:$BRANCH-common \
&& docker push dontdrinkandroot/php:$BRANCH-test \
&& docker push dontdrinkandroot/php:$BRANCH-dev
