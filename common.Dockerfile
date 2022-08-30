FROM ubuntu:22.04
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN set -xe \
    && echo "Europe/Berlin" > /etc/timezone \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apt update \
    && apt install -qy --no-install-recommends \
        curl \
        rsync \
        gnupg \
        openssh-client \
        ca-certificates \
        git \
        unzip \
    && apt install -qy --no-install-recommends \
        php8.1-cli \
        php8.1-xml \
        php8.1-sqlite3 \
        php8.1-mysql \
        php8.1-pgsql \
        php8.1-zip \
        php8.1-mbstring \
        php8.1-curl \
        php8.1-gd \
        php8.1-intl \
        php8.1-redis \
        php8.1-apcu \
    && echo "apc.enable=1" >> /etc/php/8.1/mods-available/apcu.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt clean \
    && apt autoremove -qy \
    && echo "git:" && git --version \
    && echo "php:" && php -v \
    && echo "composer:" && composer --version \
    && echo "php modules" && php -m
