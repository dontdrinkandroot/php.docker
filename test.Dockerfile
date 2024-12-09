ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

COPY php/assertions.ini /etc/php84/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php84/conf.d/50_xdebug.ini
COPY bin/create-gitlab-release /usr/local/bin/create-gitlab-release

RUN set -xe \
    && apk --no-cache --update add \
        php84-pecl-xdebug \
        yarn \
        openssh-client
    && composer global require vimeo/psalm:^5.26 \
    && ln -sf /opt/composer/vendor/bin/psalm /usr/local/bin/psalm \
    && echo "psalm:" && psalm --version
