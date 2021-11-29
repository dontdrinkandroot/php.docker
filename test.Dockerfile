ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN apt install -qy --no-install-recommends \
        php8.1-xdebug \
    && echo "xdebug.mode=develop,coverage,debug" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "xdebug.discover_client_host=true" >> /etc/php/8.1/mods-available/xdebug.ini \
    && echo "zend.assertions=1" >> /etc/php/8.1/mods-available/assertions.ini \
    && echo "assert.exception=1" >> /etc/php/8.1/mods-available/assertions.ini \
    && phpenmod assertions \
    && echo "##### INSTALL PSALM #####" \
    && curl -sL https://github.com/vimeo/psalm/releases/latest/download/psalm.phar > /usr/local/bin/psalm \
    && chmod +x /usr/local/bin/psalm \
    && echo "##### CLEANUP #####" \
    && apt-get clean \
    && apt autoremove -qy
