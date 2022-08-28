ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "##### INSTALL DEPENDENCIES #####" \
    && apk --no-cache --update add \
        php81-pecl-xdebug \
    && echo "xdebug.mode=develop,coverage,debug" >> /etc/php81/conf.d/03_xdebug.ini \
    && echo "xdebug.discover_client_host=true" >> /etc/php81/conf.d/03_xdebug.ini \
    && echo "zend.assertions=1" >> /etc/php81/conf.d/03_assertions.ini \
    && echo "assert.exception=1" >> /etc/php81/conf.d/03_assertions.ini \
    && echo "##### INSTALL PSALM #####" \
    && curl -sL https://github.com/vimeo/psalm/releases/latest/download/psalm.phar > /usr/local/bin/psalm \
    && chmod +x /usr/local/bin/psalm
