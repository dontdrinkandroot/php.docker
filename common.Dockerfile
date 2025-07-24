FROM alpine:3.22
MAINTAINER Philip Washington Sorst <philip@sorst.net>

ENV COMPOSER_HOME="/opt/composer"

RUN set -xe \
    && apk --no-cache --update add \
        curl \
        git \
        tzdata \
        icu-data-full \
        php84 \
        php84-ctype \
        php84-curl \
        php84-dom \
        php84-exif \
        php84-fileinfo \
        php84-gd \
        php84-iconv \
        php84-intl \
        php84-mbstring \
        php84-openssl \
        php84-zip \
        php84-opcache \
        php84-pdo_mysql \
        php84-pdo_pgsql \
        php84-pdo_sqlite \
        php84-pecl-apcu \
        php84-pcntl \
        php84-phar \
        php84-posix \
        php84-simplexml \
        php84-sodium \
        php84-session \
        php84-tokenizer \
        php84-xml \
        php84-xmlwriter\
    && ln -sf /usr/bin/php84 /usr/bin/php \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && git --version \
    && php -v \
    && composer --version \
    && php -m

COPY php/apcu.ini /etc/php84/conf.d/apcu.ini
