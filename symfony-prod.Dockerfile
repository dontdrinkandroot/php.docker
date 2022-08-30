ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && apk --no-cache --update add \
        apache2 \
        php81-apache2 \
        php81-pecl-apcu \
    && ln -sf /run/apache2 /etc/apache2/run \
    && ln -sf /usr/lib/apache2 /etc/apache2/modules \
    && deluser xfs \
    && delgroup www-data \
    && addgroup -g 33 -S www-data \
    && adduser -u 33 -D -S www-data -G www-data \
    && rm -rf /var/www \
    && mkdir -p /var/www/ \
    && chown www-data:www-data /var/www/ \
    && mkdir -p /var/log/app/ \
    && chown www-data:www-data /var/log/app/

COPY apache/httpd.conf /etc/apache2/httpd.conf
COPY apache/vhost-symfony-prod.conf /etc/apache2/conf.d/vhost.conf
COPY php/uploads.ini /etc/php81/conf.d/05_uploads.ini
COPY php/symfony.ini /etc/php81/conf.d/05_symfony.ini

#HEALTHCHECK CMD wget -q --no-cache --spider localhost

WORKDIR /var/www/

CMD ["httpd", "-D", "FOREGROUND"]
EXPOSE 80
