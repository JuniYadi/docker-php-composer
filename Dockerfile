# Load PHP 7.2 Alpine Version
FROM php:7.2-fpm-alpine

# Install Extention
# - redis
RUN apk add --no-cache \
        pcre-dev \
        $PHPIZE_DEPS \
        curl \
        libtool \
        libxml2-dev \
    && pecl install redis \
    && docker-php-ext-enable redis

# Default Work DIR
WORKDIR /code

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Expose PHP Port
EXPOSE 9000

CMD ["php-fpm"]
