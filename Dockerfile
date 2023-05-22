<<<<<<< HEAD
FROM php:8.2-fpm as php
=======
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/laradock
>>>>>>> origin/main

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
<<<<<<< HEAD
    libpq-dev \
=======
>>>>>>> origin/main
    sudo \
    unzip \
    zip \
    nano

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

<<<<<<< HEAD
# Install docker PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd pdo pdo_mysql sockets

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Redis
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \ 
    && docker-php-ext-enable redis

# Specify working directory
WORKDIR /var/www

# copy and place directory files into working directory
COPY . .
=======
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd pdo pdo_mysql sockets


# add user ubuntu, add group ubuntu
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo,www-data -u 1000 ubuntu
RUN groupadd ubuntu

>>>>>>> origin/main

# Get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

<<<<<<< HEAD
ENV PORT=8000
# specify entry point to run bash scripts
# this bash scripts contains commands running migrations and others
ENTRYPOINT [ "docker-files/entrypoint.sh" ]
=======
>>>>>>> origin/main

# =================================================================
# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get update && apt-get install -y \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

RUN rm nodesource_setup.sh
<<<<<<< HEAD

WORKDIR /var/www
COPY . .

RUN npm install --global cross-env
RUN npm install

VOLUME /var/www/node_modules








=======
>>>>>>> origin/main
