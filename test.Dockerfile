ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "zend.assertions=1" >> /etc/php/8.0/mods-available/assertions.ini \
    && echo "assert.exception=1" >> /etc/php/8.0/mods-available/assertions.ini \
    && phpenmod assertions
