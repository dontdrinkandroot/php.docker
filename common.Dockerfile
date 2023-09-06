FROM alpine:edge
MAINTAINER Philip Washington Sorst <philip@sorst.net>

ENV COMPOSER_HOME="/opt/composer"

RUN set -xe \
    && apk --no-cache --update add \
        curl \
        git \
        tzdata \
        icu-data-full \
        php82 \
        php82-ctype \
        php82-curl \
        php82-dom \
        php82-exif \
        php82-fileinfo \
        php82-gd \
        php82-iconv \
        php82-intl \
        php82-mbstring \
        php82-openssl \
        php82-zip \
        php82-opcache \
        php82-pdo_mysql \
        php82-pdo_pgsql \
        php82-pdo_sqlite \
        php82-pecl-apcu \
        php82-phar \
        php82-simplexml \
        php82-sodium \
        php82-session \
        php82-tokenizer \
        php82-xml \
        php82-xmlwriter\
    && ln -sf /usr/bin/php82 /usr/bin/php \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && git --version \
    && php -v \
    && composer --version \
    && php -m
