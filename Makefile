# setup a project
.RECIPEPREFIX +=

setup:
	cp .env.example .env
	docker compose up -d --build

teardown:
	docker compose down
	docker compose rm -f
	rm -f .env
	rm -f /node_modules

up:
	docker compose up -d

down:
	docker compose down


rebuild:
	docker-compose build --no-cache
	docker-compose up -d --force-recreate

db_shell:
	docker exec -it db_server /bin/bash

shell:
	docker exec -it app_server /bin/bash