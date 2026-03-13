ARG FROM=dunglas/frankenphp:1.12.1-php8.5
FROM ${FROM}
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

ENV RUN_DOCTRINE_MIGRATIONS=1
ENV DUMP_COMPOSER_ENV=1

RUN set -eux; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    mkdir -p /etc/frankenphp/supervisor.d; \
    chown -R www-data:www-data /etc/frankenphp/supervisor.d;
COPY --link files/symfony-prod.ini $PHP_INI_DIR/app.conf.d/50-symfony-prod.ini
COPY --link files/prod.Caddyfile /etc/frankenphp/Caddyfile
COPY --link --chmod=755 files/caddy-add-messenger-consume /usr/local/bin/caddy-add-messenger-consume

WORKDIR /app
USER www-data
