FROM ubuntu:20.04
MAINTAINER Philip Washington Sorst <philip@sorst.net>

RUN echo "Europe/Berlin" > /etc/timezone \
    && ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && apt update \
    && apt install -qy --no-install-recommends \
        curl \
        rsync \
        gnupg \
        openssh-client \
        ca-certificates \
        git \
        unzip \
    # Add PHP PPA
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C \
    # Add Yarn sources
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # Update added sources
    && apt-get update \
    # Install Deps
    && apt install -qy --no-install-recommends \
        php8.0-cli \
        php8.0-xml \
        php8.0-sqlite3 \
        php8.0-mysql \
        php8.0-zip \
        php8.0-mbstring \
        php8.0-curl \
        php8.0-gd \
        php8.0-intl \
        php8.0-redis \
        npm \
        yarn\
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean
