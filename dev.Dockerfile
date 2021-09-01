ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN apt install -qy --no-install-recommends \
        apache2 \
        libapache2-mod-php8.0 \
    && a2enmod rewrite \
    && apt clean \
    && apt autoremove -qy

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
