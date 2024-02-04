ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        php83-pecl-xdebug \
        yarn \
        openssh-client \
    && composer global require vimeo/psalm:^5.21 \
    && ln -sf /opt/composer/vendor/bin/psalm /usr/local/bin/psalm \
    && echo "psalm:" && psalm --version

COPY php/assertions.ini /etc/php83/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php83/conf.d/50_xdebug.ini
COPY bin/create-gitlab-release /usr/local/bin/create-gitlab-release
