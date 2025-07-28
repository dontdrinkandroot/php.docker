ARG FROM=""
FROM $FROM
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

RUN set -xe \
    && apk --no-cache --update add \
        apache2 \
        supervisor \
        php84-apache2 \
    && ln -sf /run/apache2 /etc/apache2/run \
    && ln -sf /usr/lib/apache2 /etc/apache2/modules \
    && delgroup www-data \
    && addgroup -g 33 -S www-data \
    && adduser -u 33 -D -S www-data -G www-data \
    && rm -rf /var/www \
    && mkdir -p /var/www/ \
    && chown www-data:www-data /var/www/ \
    && mkdir -p /var/log/app/ \
    && chown www-data:www-data /var/log/app/

COPY bin/entrypoint_prod.sh /usr/local/bin/entrypoint.sh
COPY bin/supervisor-add-messenger-consume /usr/local/bin/supervisor-add-messenger-consume
COPY apache/httpd.conf /etc/apache2/httpd.conf
COPY apache/vhost-symfony-prod.conf /etc/apache2/conf.d/vhost.conf
COPY php/symfony.ini /etc/php84/conf.d/05_symfony.ini
COPY supervisor/supervisord.conf /etc/supervisord.conf
COPY supervisor/programs/*.conf /etc/supervisor/conf.d/

#HEALTHCHECK CMD wget -q --no-cache --spider localhost

WORKDIR /var/www/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord"]
EXPOSE 80
