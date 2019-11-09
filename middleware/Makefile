# To apply self documented help command,
# make target with following two sharp '##' enable to show the help message.
# If you wish not to display the help message, create taget with no comment or single sharp to comment.
COCKROACH_ADMIN_PORT := 8080

.PHONY: help
help: ## show this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: up
up: ## docker-compose up -d
	@cd docker && \
	docker-compose down -v && \
	docker-compose up -d
	@make cockroach-admin
	@make cockroach-init

.PHONY: down
down: ## docker-compose down
	@cd docker && \
	docker-compose down -v

.PHONY: all-clean
all-clean: ## reset persistent
	@make cockroach-clean
	@make postgres-clean
	@make down

.PHONY: cockroach-up
cockroach-up: ## start CockroachDB
	@cd docker && \
	docker-compose up -d cockroach-master cockroach-node1 cockroach-node2 cockroach-node3
	@make cockroach-init
	@make cockroach-admin

.PHONY: cockroach-down
cockroach-down: ## stop CockroachDB
	@cd docker && \
	docker-compose rm -vsf cockroach-master cockroach-node1 cockroach-node2 cockroach-node3

.PHONY: cockroach-init
cockroach-init: ## create database and user (don't have password)
	@bash docker/scripts/cockroach_init.sh

.PHONY: cockroach-migrate
cockroach-migrate: ## create tables if not exist (DB migration)
	@bash docker/scripts/cockroach_migrate.sh

.PHONY: cockroach-cert
cockroach-cert: ## create cert file
	@bash docker/scripts/cockroach_cert_create_in_docker.sh

.PHONY: cockroach-admin
cockroach-admin: ## open cockroach admin page
	@if type open > /dev/null 2>&1; then \
		while ! nc -w 1 -z localhost $(COCKROACH_ADMIN_PORT) > /dev/null 2>&1; do sleep 0.1; done ; \
		open "http://localhost:$(COCKROACH_ADMIN_PORT)"; \
	fi

.PHONY: cockroach-clean
cockroach-clean: ## remove persistent data for CockroachDB
	@make cockroach-down
	@rm -rf docker/var/cockroach/data_* docker/var/cockroach/certs

.PHONY: postgres-up
postgres-up: ## start PostgreSQL
	@cd docker && \
	docker-compose up -d postgres

.PHONY: postgres-down
postgres-down: ## stop PostgreSQL
	@cd docker && \
	docker-compose rm -vsf postgres

.PHONY: postgres-clean
postgres-clean: ## remove persistent data for PostgreSQL
	@make postgres-down
	@rm -rf docker/var/postgres/data

.PHONY: keydb-up
keydb-up: ## start KeyDB (Multi Thread Redis)
	@cd docker && \
	docker-compose up -d keydb

.PHONY: keydb-down
keydb-down: ## stop KeyDB (Multi Thread Redis)
	@cd docker && \
	docker-compose rm -vsf keydb

.PHONY: redis-up
redis-up: ## start KeyDB (Multi Thread Redis)
	@make keydb-up

.PHONY: redis-down
redis-down: ## stop KeyDB (Multi Thread Redis)
	@make keydb-down

