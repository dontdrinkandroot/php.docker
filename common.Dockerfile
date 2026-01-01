FROM alpine:3.23
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

ENV COMPOSER_HOME="/opt/composer"

RUN set -xe \
    && apk --no-cache --update add \
        curl \
        git \
        tzdata \
        icu-data-full \
        php85 \
        php85-ctype \
        php85-curl \
        php85-dom \
        php85-exif \
        php85-fileinfo \
        php85-gd \
        php85-iconv \
        php85-intl \
        php85-mbstring \
        php85-openssl \
        php85-zip \
        php85-pdo_mysql \
        php85-pdo_pgsql \
        php85-pdo_sqlite \
        php85-pecl-apcu \
        php85-pcntl \
        php85-phar \
        php85-posix \
        php85-simplexml \
        php85-sodium \
        php85-session \
        php85-tokenizer \
        php85-xml \
        php85-xmlwriter\
    && ln -sf /usr/bin/php85 /usr/bin/php \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && git --version \
    && php -v \
    && composer --version \
    && php -m

COPY php/apcu.ini /etc/php85/conf.d/apcu.ini
