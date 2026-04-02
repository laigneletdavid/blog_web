# Blog Web — Makefile
# Usage: make <target>

DOCKER = docker compose
DOCKER_PROD = docker compose -f docker-compose.yml -f docker-compose.prod.yml
PHP    = $(DOCKER) exec php
NPM    = $(DOCKER) run --rm -w /var/www/html node npm

.PHONY: help up down restart sh db migrate cc assets assets-build logs test deploy backup restore update

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

## — Database Export ———————————————————————————
db-dump: ## Dump database to .claude/docs/blogweb_dump.sql
	@echo "Dumping database..."
	$(DOCKER) exec db mariadb-dump -uapp -papp blog_web > .claude/docs/blogweb_dump.sql
	@head -5 .claude/docs/blogweb_dump.sql
	@echo "Dump OK: .claude/docs/blogweb_dump.sql"

## — Logs ——————————————————————————————————————
logs: ## Show all container logs
	$(DOCKER) logs -f

## — Tests —————————————————————————————————————
test: ## Run PHPUnit tests
	$(PHP) php bin/phpunit

## — Mise a jour ———————————————————————————————
update: ## Update client site (pull + composer + migrate + assets + cache)
	@echo "=== BlogWeb — Mise a jour ==="
	@echo "[1/5] Pull du code..."
	git pull --ff-only
	@echo "[2/5] Dependances PHP..."
	$(PHP) composer install --no-interaction
	@echo "[3/5] Migrations BDD..."
	$(PHP) php bin/console doctrine:migrations:migrate --no-interaction
	@echo "[4/5] Build des assets..."
	$(NPM) install
	$(NPM) run dev
	@echo "[5/5] Cache..."
	$(PHP) php bin/console cache:clear
	@echo "=== Mise a jour terminee ==="

## — Production ————————————————————————————————
deploy: ## Deploy (pull + install + migrate + cache + assets)
	./scripts/deploy.sh

backup: ## Backup database (compressed)
	./scripts/backup.sh

restore: ## Restore database from backup file (usage: make restore FILE=path/to/backup.sql.gz)
	@test -n "$(FILE)" || (echo "Usage: make restore FILE=path/to/backup.sql.gz" && exit 1)
	gunzip -c "$(FILE)" | $(DOCKER) exec -T db mysql -uapp -papp blog_web
