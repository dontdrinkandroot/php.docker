ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

COPY php/uploads.ini /etc/php/8.1/mods-available/uploads.ini

RUN set -xe \
    && apt install -qy --no-install-recommends \
        apache2 \
        libapache2-mod-php8.1 \
    && phpenmod -s apache2 uploads \
    && a2enmod rewrite \
    && apt clean \
    && apt autoremove -qy

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
