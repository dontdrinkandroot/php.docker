ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN apt install -qy --no-install-recommends \
        apache2 \
        libapache2-mod-php7.4 \
    && a2enmod rewrite \
    && apt-get clean

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
