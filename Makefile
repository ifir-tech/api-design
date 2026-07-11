# Makefile for epc-al-anifiyat api-design
# Wraps npm scripts and docker compose for OpenAPI authoring & review.

SHELL   := /bin/sh
NPM     := pnpm
COMPOSE := docker compose

# Single source of truth for the API-surface specs.
SPECS := \
	src/console/openapi.yaml

# Prism mock-server container names from docker-compose.yml.
MOCKS := console

.DEFAULT_GOAL := help

.PHONY: help install \
        lint lint-spectral lint-redocly \
        swagger-ui swagger-ui-stop \
        console console-stop \
        mocks mocks-stop \
        up stop down restart logs ps clean

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "; printf "Targets:\n"} \
	      /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	$(NPM) install

# --- Linting ----------------------------------------------------------------

lint: lint-spectral lint-redocly ## Run all OpenAPI linters

lint-spectral: ## Lint specs with Stoplight Spectral
	$(NPM) exec spectral lint -r .spectral.yaml $(SPECS)

lint-redocly: ## Lint specs with Redocly CLI
	$(NPM) exec redocly lint $(SPECS)

# --- Swagger UI (docs) ------------------------------------------------------

swagger-ui: ## Start Swagger UI alone on http://localhost:8080
	$(COMPOSE) up -d swagger-ui

swagger-ui-stop: ## Stop the Swagger UI container
	$(COMPOSE) stop swagger-ui

# --- Individual Prism mock servers -----------------------------------------

console: ## Start the console mock alone on :4010
	$(COMPOSE) up -d console

console-stop: ## Stop the console mock
	$(COMPOSE) stop console


# --- All mocks at once ------------------------------------------------------

mocks: ## Start all Prism mocks (admin + portal)
	$(COMPOSE) up -d $(MOCKS)

mocks-stop: ## Stop all Prism mocks (containers preserved)
	$(COMPOSE) stop $(MOCKS)

# --- Whole-stack lifecycle --------------------------------------------------

up: ## Start everything in detached mode (docs + mocks)
	$(COMPOSE) up -d

stop: ## Stop every service (containers preserved, fast restart)
	$(COMPOSE) stop

down: ## Stop AND remove every container/network
	$(COMPOSE) down

restart: ## Restart every service in place
	$(COMPOSE) restart

logs: ## Tail logs from every running service
	$(COMPOSE) logs -f

ps: ## Show status of compose services
	$(COMPOSE) ps

clean: ## Stop services and prune volumes/orphans
	$(COMPOSE) down -v --remove-orphans
