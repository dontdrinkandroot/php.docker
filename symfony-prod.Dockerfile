ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

COPY php/uploads.ini /etc/php/8.1/mods-available/uploads.ini
COPY php/symfony.ini /etc/php/8.1/mods-available/symfony.ini

RUN set -xe \
    && apt install -qy --no-install-recommends \
        apache2 \
        libapache2-mod-php8.1 \
    && a2enmod rewrite headers \
    && rm -rf /var/www/html \
    && chown -R www-data:www-data /var/www \
    && echo "ErrorLog /dev/stderr" > /etc/apache2/conf-available/errorlog.conf \
    && a2enconf errorlog \
    && apt-get clean \
    && apt autoremove -qy \
    && phpenmod -s apache2 uploads \
    && phpenmod -s apache2 symfony

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
