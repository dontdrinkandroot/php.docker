ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        php81-pecl-xdebug \
    && curl -sL https://github.com/vimeo/psalm/releases/latest/download/psalm.phar > /usr/local/bin/psalm \
    && chmod +x /usr/local/bin/psalm

COPY php/assertions.ini /etc/php81/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php81/conf.d/50_xdebug.ini
