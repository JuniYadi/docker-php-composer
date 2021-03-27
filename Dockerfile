FROM php:7.2-fpm-alpine
RUN apk add --no-cache \
        pcre-dev \
        $PHPIZE_DEPS \
        curl \
        libtool \
        libxml2-dev \
    && pecl install redis \
    && docker-php-ext-enable redis

WORKDIR /code

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install

EXPOSE 9000

CMD ["php-fpm"]
