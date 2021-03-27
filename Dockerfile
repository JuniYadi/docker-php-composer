# Load PHP Alpine Version
FROM php:8.0-fpm-alpine

# Argument
ARG PRODUCTION

# Install Extention
# - redis
# - gd
# - mysql + pdo_mysql
RUN set -eux \
    && apk add --no-cache --virtual .build-deps \
        pcre-dev \
        $PHPIZE_DEPS \
        coreutils \
        curl \
        libtool \
        libxml2-dev \
        libpng \
        libpng-dev \
        libjpeg-turbo \
        libwebp-dev \
        freetype-dev \
        libjpeg-turbo-dev \
    && pecl install redis \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-freetype \
        --with-jpeg \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd mysqli pdo pdo_mysql \
    && docker-php-ext-enable redis \
    && docker-php-source delete \
    && apk del \
        .build-deps \
        libwebp-dev \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
    && true

# PHP Default Configuration
RUN if [ $PRODUCTION == true ]; then RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; fi
RUN if [ $PRODUCTION == false ]; then RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; fi

# PHP Custom Configuration
COPY ./php/local.ini /usr/local/etc/php/conf.d/local.ini

# Default Work DIR
WORKDIR /code

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Expose PHP Port
EXPOSE 9000

CMD ["php-fpm"]