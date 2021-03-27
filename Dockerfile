# Load PHP Alpine Version
FROM php:7.4-fpm-alpine

# Install Extention
# - redis
RUN apk add --no-cache \
        pcre-dev \
        $PHPIZE_DEPS \
        curl \
        libtool \
        libxml2-dev \
    && pecl install redis \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable redis

# Default Work DIR
WORKDIR /code

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Expose PHP Port
EXPOSE 9000

CMD ["php-fpm"]
