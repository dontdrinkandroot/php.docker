FROM dunglas/frankenphp:1.12.1-builder-php8.5 AS builder
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

ENV COMPOSER_CACHE_DIR=composer-cache

# Copy xcaddy in the builder image
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
RUN CGO_ENABLED=1 \
    XCADDY_SETCAP=1 \
    XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx" \
    CGO_CFLAGS=$(php-config --includes) \
    CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
    xcaddy build \
        --output /usr/local/bin/frankenphp \
        --with github.com/dunglas/frankenphp=./ \
        --with github.com/dunglas/frankenphp/caddy=./caddy/ \
        --with github.com/dunglas/caddy-cbrotli \
        --with github.com/baldinof/caddy-supervisor

FROM dunglas/frankenphp:1.12.1-php8.5 AS runner

# Replace the official binary by the one contained your custom modules
COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp
COPY --link --chmod=755 files/docker-entrypoint /usr/local/bin/docker-entrypoint

RUN set -eux; \
    install-php-extensions \
        @composer \
        apcu \
        gd \
        intl \
        opcache \
        pdo_sqlite \
        pdo_pgsql \
        zip; \
    mkdir -p "$PHP_INI_DIR/app.conf.d" \
        /config/caddy \
        /data/caddy/locks; \
    touch "$PHP_INI_DIR/app.conf.d/60_docker_env.ini"; \
    chown www-data:www-data "$PHP_INI_DIR/app.conf.d/60_docker_env.ini"; \
    chown -R www-data:www-data /config/caddy /data/caddy /app;

ENTRYPOINT ["docker-entrypoint"]
CMD ["frankenphp", "run", "--config", "/etc/frankenphp/Caddyfile"]
EXPOSE 80 443 443/udp
