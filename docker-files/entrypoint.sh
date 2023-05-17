#! /bin/bash


# install composer dependencies
if [ ! -f "vendor/autoload.php" ]; then
    #if depencies has already been installed don't rerun
    composer install --no-progress --no-interaction
fi #end if

# copy .env.example file if .env file does not exist
if [ ! -f ".env"]; then
    echo "Creating .env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file exists"
fi

php artisan migrate
php artisan key:generate
php artisan optimize:clear
php artisan artisan db:seed

php artisan serve --port=$PORT --host=0.0.0.0 --env=.env

# execute default docker php entry point
exec docker-php-entrypoint "$@"


