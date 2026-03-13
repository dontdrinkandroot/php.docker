FROM alpine:3.23
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

ENV COMPOSER_HOME="/opt/composer"

RUN set -eux \
    && apk add --no-cache \
        curl \
        git \
        icu-data-full \
        openssh-client \
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
        php85-pcntl \
        php85-pdo_mysql \
        php85-pdo_pgsql \
        php85-pdo_sqlite \
        php85-pecl-apcu \
        php85-pecl-xdebug \
        php85-phar \
        php85-posix \
        php85-session \
        php85-simplexml \
        php85-sodium \
        php85-tokenizer \
        php85-xml \
        php85-xmlwriter \
        php85-zip \
        pnpm \
        tzdata \
        yarn \
    && ln -sf /usr/bin/php85 /usr/bin/php \
    && echo "Europe/Berlin" > /etc/timezone \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apk del tzdata \
    && curl -fsSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global config --no-plugins allow-plugins.phpstan/extension-installer true \
    && composer global require \
        phpstan/phpstan:^2.1.2 \
        phpstan/phpstan-symfony:^2.0 \
        phpstan/phpstan-doctrine:^2.0 \
        phpstan/phpstan-strict-rules:^2.0 \
        phpstan/extension-installer:^1.4 \
    && composer global config --no-plugins allow-plugins.phpstan/extension-installer false \
    && ln -sf /opt/composer/vendor/bin/phpstan /usr/local/bin/phpstan \
    && git --version \
    && php -v \
    && composer --version \
    && phpstan --version \
    && php -m

COPY files/apcu.ini /etc/php85/conf.d/apcu.ini
COPY files/assertions.ini /etc/php85/conf.d/04_assertions.ini
COPY files/xdebug.ini /etc/php85/conf.d/50_xdebug.ini
COPY files/create-gitlab-release /usr/local/bin/create-gitlab-release
