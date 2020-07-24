FROM php:7.4.7-fpm-alpine3.12

# Install dependencies
RUN apk update && apk add --no-cache curl \
    zip \
    unzip \
    git \
    libpq \
    redis \
    composer \
    bash \
    nano \
    libpng \
    jpegoptim \
    gifsicle \
    pngquant \
    optipng \
    supervisor

# Install PDO driver mysql
RUN docker-php-ext-install mysqli

# Install PDO driver psql
RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install pdo pdo_pgsql

# Install sockets
RUN docker-php-ext-install sockets

# Delete cache folder
RUN rm -rf /var/cache/apk/*

# Create supervisor.sock
RUN touch /tmp/supervisor.sock

# COPY default .conf file
COPY supervisord.conf /etc/supervisord.conf

# Run supervisor
CMD supervisord -n -c /etc/supervisord.conf
