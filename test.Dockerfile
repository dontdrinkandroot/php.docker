ARG FROM=""
FROM $FROM
MAINTAINER Philip Washington Sorst <philip@sorst.net>

COPY php/assertions.ini /etc/php84/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php84/conf.d/50_xdebug.ini
COPY bin/create-gitlab-release /usr/local/bin/create-gitlab-release

RUN set -xe \
    && apk --no-cache --update add \
        php84-pecl-xdebug \
        pnpm \
        yarn \
        openssh-client \
    && composer global require vimeo/psalm:^6.0 phpstan/phpstan:^2.1.2 phpstan/phpstan-symfony:^2.0 phpstan/phpstan-doctrine:^2.0 phpstan/extension-installer:^1.4 \
    && ln -sf /opt/composer/vendor/bin/psalm /usr/local/bin/psalm \
    && ln -sf /opt/composer/vendor/bin/phpstan /usr/local/bin/phpstan \
    && echo "psalm:" && psalm --version
