ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN apt install -qy --no-install-recommends \
        php8.0-xdebug \
    && echo "xdebug.remote_enable=1" >> /etc/php/8.0/mods-available/xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php/8.0/mods-available/xdebug.ini \
    && echo "zend.assertions=1" >> /etc/php/8.0/mods-available/assertions.ini \
    && echo "assert.exception=1" >> /etc/php/8.0/mods-available/assertions.ini \
    && phpenmod assertions \
    && apt-get clean \
    && php -i
