FROM php:8.4-fpm-alpine AS base

# System dependencies
RUN apk add --no-cache \
    icu-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    oniguruma-dev \
    linux-headers \
    fcgi \
    $PHPIZE_DEPS

# PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        intl \
        gd \
        zip \
        opcache \
        mbstring

# APCu
RUN pecl install apcu && docker-php-ext-enable apcu

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# php-fpm healthcheck script
RUN printf '#!/bin/sh\nSCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 2>/dev/null | grep -q pong\n' > /usr/local/bin/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

# Enable php-fpm ping endpoint
RUN printf '\n[www]\nping.path = /ping\nping.response = pong\n' >> /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /var/www/html

# Non-root user
RUN addgroup -g 1000 app && adduser -u 1000 -G app -s /bin/sh -D app
RUN chown -R app:app /var/www/html

# --- Development target (default) ---
FROM base AS dev

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY php.ini /usr/local/etc/php/conf.d/app.ini

USER app

# --- Production target ---
FROM base AS prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php.ini.prod /usr/local/etc/php/conf.d/app.ini

USER app
