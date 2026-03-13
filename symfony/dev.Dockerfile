ARG FROM=dunglas/frankenphp:1.12.1-php8.5
FROM ${FROM}
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY --link files/assertions.ini $PHP_INI_DIR/app.conf.d/04_assertions.ini
COPY --link files/xdebug.ini $PHP_INI_DIR/app.conf.d/50_xdebug.ini
COPY --link files/dev.Caddyfile /etc/frankenphp/Caddyfile

RUN install-php-extensions \
	xdebug

WORKDIR /app
USER www-data
