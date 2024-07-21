FROM php:8.3.9-fpm

ARG NODE_VERSION=20

RUN groupadd -g 1000 wordpress
RUN useradd -r -m -s /usr/sbin/nologin -g wordpress -u 1000 wordpress

RUN curl -sLS https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y \
    && apt-get install -y \
        busybox gnupg gosu wget curl ca-certificates zip unzip git sqlite3 dnsutils \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmagickwand-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libpng-dev \
        nodejs \
        yarn \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j "$(nproc)" bcmath exif gd intl mysqli opcache pdo_mysql zip \
    && pecl install xdebug --with-maximum-processors="$(nproc)" \
    && docker-php-ext-enable xdebug \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install composer
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Install WP-CLI
RUN curl -sLS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/bin/wp \
    && chmod +x /usr/bin/wp

ADD ./docker/php.entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0777 /usr/local/bin/entrypoint.sh -R
ENTRYPOINT /usr/local/bin/entrypoint.sh
