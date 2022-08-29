ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "INSTALL DEPENDENCIES " \
    && apk --no-cache --update add \
        apache2 \
        php81-apache2 \
    && echo "##### CONFIGURE UPLOADS #####" \
    && echo "upload_max_filesize = 128M" >> /etc/php81/conf.d/03_uploads.ini \
    && echo "post_max_size = 128M" >> /etc/php81/conf.d/03_uploads.ini \
    && echo "##### CONFIGURE APACHE #####" \
    && sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf \
    && sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf \
    && sed -i 's/User apache/User www-data/' /etc/apache2/httpd.conf \
    && sed -i 's/Group apache/Group www-data/' /etc/apache2/httpd.conf \
    && deluser xfs \
    && delgroup www-data \
    && addgroup -g 33 -S www-data \
    && adduser -u 33 -D -S www-data -G www-data \
    && mkdir -p /opt/app/ \
    && chown www-data:www-data /opt/app/

COPY apache/vhost-symfony-dev.conf /etc/apache2/conf.d/vhost.conf

WORKDIR /opt/app/

CMD ["httpd", "-D", "FOREGROUND"]
EXPOSE 80
