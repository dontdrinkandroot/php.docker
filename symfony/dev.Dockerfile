ARG FROM=dunglas/frankenphp:1.12.1-php8.5
FROM ${FROM}
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

ENV RUN_DOCTRINE_MIGRATIONS=0
ENV DUMP_COMPOSER_ENV=0

RUN set -eux; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    install-php-extensions \
        xdebug;

COPY --link files/assertions.ini $PHP_INI_DIR/app.conf.d/04_assertions.ini
COPY --link files/xdebug.ini $PHP_INI_DIR/app.conf.d/50_xdebug.ini
COPY --link files/dev.Caddyfile /etc/frankenphp/Caddyfile

WORKDIR /app
USER www-data
