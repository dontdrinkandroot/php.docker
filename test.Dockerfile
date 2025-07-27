ARG FROM=""
FROM $FROM
LABEL maintainer="Philip Washington Sorst <philip@sorst.net>"

COPY php/assertions.ini /etc/php84/conf.d/04_assertions.ini
COPY php/xdebug.ini /etc/php84/conf.d/50_xdebug.ini
COPY bin/create-gitlab-release /usr/local/bin/create-gitlab-release

RUN set -xe \
    && apk --no-cache --update add \
        php84-pecl-xdebug \
        pnpm \
        yarn \
        openssh-client \
    && composer global config --no-plugins allow-plugins.phpstan/extension-installer true \
    && composer global require phpstan/phpstan:^2.1.2 phpstan/phpstan-symfony:^2.0 phpstan/phpstan-doctrine:^2.0 phpstan/phpstan-strict-rules:^2.0 phpstan/extension-installer:^1.4 \
    && composer global config --no-plugins allow-plugins.phpstan/extension-installer false \
    && ln -sf /opt/composer/vendor/bin/phpstan /usr/local/bin/phpstan \
    && echo "phpstan:" && phpstan --version
