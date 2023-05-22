FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/laradock

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libreadline-dev \
    libonig-dev \
    sudo \
    unzip \
    zip \
    nano

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd pdo pdo_mysql sockets


# add user ubuntu, add group ubuntu
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo,www-data -u 1000 ubuntu
RUN groupadd ubuntu


# Get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer


# =================================================================
# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get update && apt-get install -y \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

RUN rm nodesource_setup.sh
