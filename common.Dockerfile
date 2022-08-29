FROM alpine:3.16
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "##### INSTALL DEPENDENCIES #####" \
    && apk --no-cache --update add \
        curl \
        git \
        tzdata \
        php81 \
        php81-ctype \
        php81-curl \
        php81-dom \
        php81-gd \
        php81-iconv \
        php81-intl \
        php81-mbstring \
        php81-openssl \
        php81-zip \
        php81-pdo_mysql \
        php81-pdo_pgsql \
        php81-pdo_sqlite \
        php81-phar \
        php81-simplexml \
        php81-sodium \
        php81-session \
        php81-tokenizer \
        php81-xml \
        php81-xmlwriter\
    && ln -sf /usr/bin/php81 /usr/bin/php \
    && echo "##### INSTALL COMPOSER #####" \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && echo "##### SHOW VERSIONS #####" \
    && echo "git:" && git --version \
    && echo "php:" && php -v \
    && echo "composer:" && composer --version \
    && echo "php modules" && php -m \
    && echo "##### SET TIMEZONE #####" \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata
