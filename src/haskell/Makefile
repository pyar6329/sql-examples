.PHONY: help
help: ## show this help message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## run stack build
	@stack build --fast -j0 --ghc-options "-dynamic +RTS -A128m -RTS"

.PHONY: test
test: ## run hspec
	@ENV=test stack test --fast -j0 --ghc-options "-dynamic +RTS -A128m -RTS"

.PHONY: execute
execute: ## run main.hs
	@ENV=dev stack runghc -- -i=src -- app/Main.hs
