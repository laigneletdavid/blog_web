# Blog Web — Makefile
# Usage: make <target>

DOCKER = docker compose
PHP    = $(DOCKER) exec php
NPM    = $(DOCKER) run --rm -w /var/www/html node npm

.PHONY: help up down restart sh db migrate cc assets assets-build logs test

## — Docker ————————————————————————————————————
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

up: ## Start all containers
	$(DOCKER) up -d --build

down: ## Stop and remove containers
	$(DOCKER) down

restart: ## Restart containers
	$(DOCKER) restart

sh: ## Open a shell in the PHP container
	$(PHP) sh

## — Database ——————————————————————————————————
db: ## Reset DB: drop + create + migrate
	$(PHP) php bin/console doctrine:database:drop --force --if-exists
	$(PHP) php bin/console doctrine:database:create
	$(PHP) php bin/console doctrine:migrations:migrate --no-interaction

migrate: ## Run pending migrations
	$(PHP) php bin/console doctrine:migrations:migrate --no-interaction

## — Symfony ———————————————————————————————————
cc: ## Clear Symfony cache
	$(PHP) php bin/console cache:clear

## — Assets ———————————————————————————————————
assets: ## Build assets (dev)
	$(NPM) install
	$(NPM) run dev

assets-build: ## Build assets (production)
	$(NPM) install
	$(NPM) run build

## — Composer ——————————————————————————————————
composer-install: ## Install PHP dependencies
	$(PHP) composer install

composer-update: ## Update PHP dependencies
	$(PHP) composer update

## — Logs ——————————————————————————————————————
logs: ## Show all container logs
	$(DOCKER) logs -f

## — Tests —————————————————————————————————————
test: ## Run PHPUnit tests
	$(PHP) php bin/phpunit
