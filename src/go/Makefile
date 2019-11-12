# To apply self documented help command,
# make target with following two sharp '##' enable to show the help message.
# If you wish not to display the help message, create taget with no comment or single sharp to comment.

DOCKER_HOST_ADDR:="host.docker.internal"

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

.PHONY: pop-up
pop-up: ## migrate up using soda
	@docker run --rm -v $(CURDIR)/pop:/workspace -e "DEV_DATABASE_HOST=$(DOCKER_HOST_ADDR)" soda:5 migrate up

.PHONY: pop-down
pop-down: ## migrate down using soda
	@docker run --rm -v $(CURDIR)/pop:/workspace -e "DEV_DATABASE_HOST=$(DOCKER_HOST_ADDR)" soda:5 migrate down

.PHONY: sql-migrate-up
sql-migrate-up: ## migrate up using sql-migrate
	@docker run --rm -v $(CURDIR)/sql-migrate:/workspace -e "DEV_DATABASE_HOST=$(DOCKER_HOST_ADDR)" mig:1 up

.PHONY: sql-migrate-down
sql-migrate-down: ## migrate down using sql-migrate
	@docker run --rm -v $(CURDIR)/sql-migrate:/workspace -e "DEV_DATABASE_HOST=$(DOCKER_HOST_ADDR)" mig:1 down
