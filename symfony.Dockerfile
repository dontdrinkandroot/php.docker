ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "##### SETUP APACHE #####" \
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
    && echo "##### CONFIGURE UPLOADS #####" \
    && echo "; priority=50" >> /etc/php/8.1/mods-available/uploads.ini \
    && echo "upload_max_filesize = 128M" >> /etc/php/8.1/mods-available/uploads.ini \
    && echo "post_max_size = 128M" >> /etc/php/8.1/mods-available/uploads.ini \
    && phpenmod -s apache2 uploads \
    && echo "##### OPTIMIZE SYMFONY #####" \
    && echo "; priority=50" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "opcache.memory_consumption=256" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "opcache.max_accelerated_files=20000" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "opcache.validate_timestamps=0" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "realpath_cache_size=4096K" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "realpath_cache_ttl=600" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "opcache.preload=/var/www/config/preload.php" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && echo "opcache.preload_user=www-data" >> /etc/php/8.1/mods-available/symfony_performance.ini \
    && phpenmod -s apache2 symfony_performance

WORKDIR /var/www/

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
