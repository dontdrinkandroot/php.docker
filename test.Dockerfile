ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        php81-pecl-xdebug \
        yarn \
    && composer global require vimeo/psalm:^5.2 \
    && ln -sf /opt/composer/vendor/bin/psalm /usr/local/bin/psalm \
    && echo "psalm:" && psalm --version

COPY php/assertions.ini /etc/php81/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php81/conf.d/50_xdebug.ini
