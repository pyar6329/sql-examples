# To apply self documented help command,
# make target with following two sharp '##' enable to show the help message.
# If you wish not to display the help message, create taget with no comment or single sharp to comment.

IMAGE:=sql-examples
TAG:=latest

.PHONY: help
help: ## show this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: run
run: ## execute main.go
	@go run main.go

.PHONY: build
build: ## build binary
	@make clean
	@go build

.PHONY: clean
clean: ## remove build file
	@rm -rf sql-examples

.PHONY: create-image
create-image: ## create docker image
	@docker build -t $(IMAGE):$(TAG) .

.PHONY: create-cockroach-cert
create-cockroach-cert: ## create cert file
	@bash docker/scripts/create_cockroach_cert_docker.sh

.PHONY: open-cockroach-admin
open-cockroach-admin: ## open cockroach admin page
	@if type open > /dev/null 2>&1; then \
		open "http://localhost:8080"; \
	fi

.PHONY: db-run
db-run: ## rerun docker-compose
	@docker-compose down
	@docker-compose up -d
	@make open-cockroach-admin

.PHONY: db-init-cockroach
db-init-cockroach: ## create database and user (don't have password)
	@bash docker/scripts/db_init_cockroach.sh

.PHONY: db-migrate-cockroach
db-migrate-cockroach: ## create tables if not exist (DB migration)
	@bash docker/scripts/db_migrate_cockroach.sh

.PHONY: db-clean
db-clean: ## remove persistent data (CockroachDB, PostgreSQL)
	@rm -rf docker/var/cockroach/data_* docker/var/cockroach/certs docker/var/postgres/data

.PHONY: all-clean
all-clean: ## reset persistent
	@docker-compose down
	@make db-clean
	@make clean

