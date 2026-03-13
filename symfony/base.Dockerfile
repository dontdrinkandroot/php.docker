FROM dunglas/frankenphp:1.12.1-builder-php8.5 AS builder
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

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

RUN install-php-extensions \
	pdo_sqlite \
    pdo_pgsql \
	gd \
	intl \
	zip \
	opcache

ENTRYPOINT ["docker-entrypoint"]
CMD ["frankenphp", "run", "--config", "/etc/frankenphp/Caddyfile"]
EXPOSE 80 443 443/udp
