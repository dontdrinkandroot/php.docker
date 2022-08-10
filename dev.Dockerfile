ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN apt install -qy --no-install-recommends \
        apache2 \
        libapache2-mod-php8.1 \
    && echo "##### CONFIGURE UPLOADS #####" \
    && echo "; priority=50" >> /etc/php/8.1/mods-available/uploads.ini \
    && echo "upload_max_filesize = 128M" >> /etc/php/8.1/mods-available/uploads.ini \
    && echo "post_max_size = 128M" >> /etc/php/8.1/mods-available/uploads.ini \
    && phpenmod -s apache2 uploads \
    && a2enmod rewrite \
    && apt clean \
    && apt autoremove -qy

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
