# setup a project
.RECIPEPREFIX +=

setup:
	docker compose up -d --build

teardown:
	docker compose down
	docker compose rm -f
	rm -f .env

up:
	docker compose up 

down:
	docker compose down


rebuild:
	docker-compose up -d --force-recreate --build

db_shell:
	docker exec -it database /bin/bash

shell:
	docker exec -it application /bin/bash