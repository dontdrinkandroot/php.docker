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
    # Add Yarn sources
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # Update added sources
    && apt-get update \
    # Install Deps
    && apt install -qy --no-install-recommends \
        php7.4-cli \
        php7.4-xml \
        php7.4-sqlite3 \
        php7.4-mysql \
        php7.4-zip \
        php7.4-mbstring \
        php7.4-curl \
        php7.4-gd \
        php7.4-intl \
        php7.4-redis \
        php7.4-pcov \
        librsvg2-bin \
        fonts-ubuntu \
        npm \
        yarn\
    && echo "zend.assertions=1" >> /etc/php/7.4/mods-available/assertions.ini \
    && echo "assert.exception=1" >> /etc/php/7.4/mods-available/assertions.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && phpenmod assertions \
    && apt-get clean
