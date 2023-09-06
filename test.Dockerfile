ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        php82-pecl-xdebug \
    && composer global require vimeo/psalm:^5.2 \
    && ln -sf /opt/composer/vendor/bin/psalm /usr/local/bin/psalm \
    && echo "psalm:" && psalm --version

COPY php/assertions.ini /etc/php82/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php82/conf.d/50_xdebug.ini
COPY bin/create-gitlab-release /usr/local/bin/create-gitlab-release
