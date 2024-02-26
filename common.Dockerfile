FROM alpine:3.19
MAINTAINER Philip Washington Sorst <philip@sorst.net>

ENV COMPOSER_HOME="/opt/composer"

RUN set -xe \
    && apk --no-cache --update add \
        curl \
        git \
        tzdata \
        icu-data-full \
        php83 \
        php83-ctype \
        php83-curl \
        php83-dom \
        php83-exif \
        php83-fileinfo \
        php83-gd \
        php83-iconv \
        php83-intl \
        php83-mbstring \
        php83-openssl \
        php83-zip \
        php83-opcache \
        php83-pdo_mysql \
        php83-pdo_pgsql \
        php83-pdo_sqlite \
        php83-pecl-apcu \
        php83-phar \
        php83-simplexml \
        php83-sodium \
        php83-session \
        php83-tokenizer \
        php83-xml \
        php83-xmlwriter\
    && ln -sf /usr/bin/php83 /usr/bin/php \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && git --version \
    && php -v \
    && composer --version \
    && php -m

COPY php/memory.ini /etc/php83/conf.d/05_memory.ini
