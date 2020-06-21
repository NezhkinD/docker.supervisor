FROM php:7.4.7-fpm-buster

#--------------------------------------------------------------------------
# Config PHP

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Install PDO driver psql
RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

# Install PDO driver mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP Redis
ENV PHPREDIS_VERSION 3.0.0
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
     && docker-php-ext-install redis


#--------------------------------------------------------------------------
# Config Supervisor

# Install supervisor 4
RUN apt-get update && apt-get install python-pip -y
RUN pip install supervisor

RUN > /tmp/supervisor.sock

CMD supervisord -n -c /etc/supervisor/supervisord.conf