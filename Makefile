# setup a project
.RECIPEPREFIX +=

USER=ubuntu
CONTAINER_PHP=laradock
CONTAINER_DB=laradock_db
CONTAINER_REDIS=laradock_redis
CONTAINER_WEBSERVER=laradock_webserver

VOLUME_REDIS = "storage/redis"
VOLUME_DB = "storage/dbdata"
VOLUME_NODE = "node_modules"

help: ## Print help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)


setup: build up composer-install migrate npm-install npm-dev ## configure project

teardown: down remove_containers ## destroy all containers
	@if [ -d "$(VOLUME_NODE)" ]; then rm -r "$(VOLUME_NODE)"; fi

	@if [ -d "$(VOLUME_DB)" ]; then rm -r "$(VOLUME_DB)"; fi

	@if [ -d "$(CONTAINER_REDIS)" ]; then rm -r "$(VOLUME_REDIS)"; fi

	@if [ -f .env ]; then rm -f .env; fi
# teardown: down remove_containers ## destroy all containers
# 	rm -f .env
# 	rm -r node_modules
# 	rm -r storage/dbdata
# 	rm -r storage/redis

remove_containers: ## removes all stopped containers created by a docker compose file.
	@docker compose rm -f

up: ## start containers in detatched mode
	@docker compose up -d

stop: ## stop containers
	@docker compose stop

down: ## destroy containers
	@docker compose down

build: create-env ## Build defined images.
	@docker compose build --no-cache

force_start: ## force a restart of defined services
	@docker-compose up -d --force-recreate

fresh: build force_start ## a fresh recreate of all containers

db_shell: ## ssh into db container
	@docker exec -it db_server /bin/bash

shell: ## ssh into application container as user ubuntu
	@docker exec -it -u ubuntu ${CONTAINER_PHP} /bin/bash

shell_root: ## ssh into application shell as root user
	@docker exec -it ${CONTAINER_PHP} /bin/bash

ps: ## show containers
	@docker compose ps

create-env: ## Copy .env.example to .env
	@if [ ! -f ".env" ]; then \
		echo "Creating .env file."; \
		cp .env.example .env; \
	fi
composer-install: ## Install composer dependencies
	@docker exec -it -u ubuntu ${CONTAINER_PHP} composer install

npm-install: ## install frontend assets
	@docker exec -it -u ubuntu ${CONTAINER_PHP} npm install
npm-dev: ## Compile front assets for dev
	@docker exec -it -u ubuntu ${CONTAINER_PHP} npm run dev

npm-watch: ## Rebuild assets
	@docker exec -it -u ubuntu ${CONTAINER_PHP} npm run watch

npm-prod: ## Compile front assets for prod
	@docker exec -it -u ubuntu ${CONTAINER_PHP} npm run production

migrate: ## Run migration files.
	@docker exec -it -u ubuntu ${CONTAINER_PHP} php artisan migrate

migrate-fresh: ## Clear database and run all migrations.
	@docker exec -it -u ubuntu ${CONTAINER_PHP} php artisan migrate:fresh

migrate-tests-fresh: ## Clear database and run all migrations.
	@docker exec -it -u ubuntu ${CONTAINER_PHP} php artisan --env=testing migrate:fresh

logs: ## Print all docker logs
	@docker compose logs -f

logs_app: ## Print app container logs
	@docker logs ${CONTAINER_PHP}

logs_db: ## Print database container logs
	@docker logs ${CONTAINER_DB}

logs_redis: ## Print redis container logs
	@docker logs ${CONTAINER_REDIS}

install-xdebug: ## Install xdebug locally.
	docker exec ${CONTAINER_PHP} pecl install xdebug
	docker exec ${CONTAINER_PHP} /usr/local/bin/docker-php-ext-enable xdebug.so

