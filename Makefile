include .env
export

up:
	docker compose up -d postgres

down:
	docker compose down

migrate:
	docker compose run --rm dbmate up

rollback:
	docker compose run --rm dbmate rollback

load:
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < db/load/load_olist.sql

psql:
	docker compose exec postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

queries:
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < db/queries/analytics.sql

reset:
	docker compose down -v
	docker compose up -d postgres
	$(MAKE) migrate
	$(MAKE) load
