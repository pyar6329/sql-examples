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
	docker-compose down && \
	docker-compose up -d
	@make cockroach-admin
	@make cockroach-init

.PHONY: down
down: ## docker-compose down
	@cd docker && \
	docker-compose down

.PHONY: all-clean
all-clean: ## reset persistent
	@make down
	@make cockroach-clean
	@make postgres-clean

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
	@rm -rf docker/var/cockroach/data_* docker/var/cockroach/certs

.PHONY: postgres-clean
postgres-clean: ## remove persistent data for PostgreSQL
	@rm -rf docker/var/postgres/data

