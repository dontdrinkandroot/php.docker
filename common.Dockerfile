FROM ubuntu:22.04
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "##### SET TIMEZONE #####" \
    echo "Europe/Berlin" > /etc/timezone \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo "##### PREPARE BASE SYSTEM #####" \
    && apt update \
    && apt install -qy --no-install-recommends \
        curl \
        rsync \
        gnupg \
        openssh-client \
        ca-certificates \
        git \
        unzip \
#    && echo "##### ADD PHP SOURCES #####" \
#    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ondrej-php.list \
#    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C \
    && echo "##### ADD NPM SOURCES #####" \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && echo "##### ADD YARN SOURCES #####" \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && echo "##### UPDATE ADDED SOURCES #####" \
    && apt-get update \
    && echo "##### INSTALL PACKAGES #####" \
    && apt install -qy --no-install-recommends \
        php8.1-cli \
        php8.1-xml \
        php8.1-sqlite3 \
        php8.1-mysql \
        php8.1-pgsql \
        php8.1-zip \
        php8.1-mbstring \
        php8.1-curl \
        php8.1-gd \
        php8.1-intl \
        php8.1-redis \
        php8.1-apcu \
        nodejs \
        yarn\
    && echo "##### CUSTOMIZING PHP CONFIG #####" \
    && echo "apc.enable=1" >> /etc/php/8.1/mods-available/apcu.ini \
    && echo "##### INSTALL COMPOSER #####" \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && echo "##### CLEANUP #####" \
    && apt clean \
    && apt autoremove -qy \
    && echo "##### SHOW VERSIONS #####" \
    && echo "git:" && git --version \
    && echo "node" && node --version \
    && echo "npm:" && npm --v \
    && echo "yarn:" && yarn --version \
    && echo "php:" && php -v \
    && echo "composer:" && composer --version \
    && echo "php modules" && php -m
