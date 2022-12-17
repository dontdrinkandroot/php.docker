ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        apache2 \
        php82-apache2 \
    && ln -sf /run/apache2 /etc/apache2/run \
    && ln -sf /usr/lib/apache2 /etc/apache2/modules \
    && deluser xfs \
    && delgroup www-data \
    && addgroup -g 33 -S www-data \
    && adduser -u 33 -D -S www-data -G www-data \
    && rm -rf /var/www \
    && mkdir -p /var/www/ \
    && chown www-data:www-data /var/www/

COPY apache/httpd.conf /etc/apache2/httpd.conf
COPY apache/vhost-symfony-dev.conf /etc/apache2/conf.d/vhost.conf
COPY php/uploads.ini /etc/php82/conf.d/05_uploads.ini

WORKDIR /var/www/

CMD ["httpd", "-D", "FOREGROUND"]
EXPOSE 80
