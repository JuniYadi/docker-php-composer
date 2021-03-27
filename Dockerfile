# Load PHP Alpine Version
FROM php:8.0-fpm-alpine

# Argument
ARG PRODUCTION

# Install Extention
# - redis
# - gd
# - mysql + pdo_mysql
RUN apk add --no-cache \
        pcre-dev \
        $PHPIZE_DEPS \
        curl \
        libtool \
        libxml2-dev \
        libpng \
        libpng-dev \
        libjpeg-turbo \
        freetype-dev \
        libjpeg-turbo-dev \
    && pecl install redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j${nproc} gd mysqli pdo pdo_mysql \
    && docker-php-ext-enable redis \
    && apk del \
        --no-cache \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev

# PHP Default Configuration
RUN if [ $PRODUCTION == true ]; then \
        RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    else \
        RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    fi \

# PHP Custom Configuration
COPY ./php/local.ini /usr/local/etc/php/conf.d/local.ini

# Default Work DIR
WORKDIR /code

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Expose PHP Port
EXPOSE 9000

CMD ["php-fpm"]
