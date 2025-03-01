.PHONY: help db-create db-drop db-migrate db-reset sqlc

.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo "  make db-create  - Create the database"
	@echo "  make db-drop    - Drop the database"
	@echo "  make db-migrate - Run database migrations"
	@echo "  make db-reset   - Drop and recreate the database with migrations"
	@echo "  make sqlc       - Generate Go code from SQL queries using sqlc"
	@echo "  make db-seed    - Seed the database with sample data"
	@echo "  make db-full    - Reset and seed the database (full setup)"

db-create:
	go run cmd/db.go create

db-drop:
	go run cmd/db.go drop

db-migrate:
	go run cmd/db.go migrate

db-reset:
	go run cmd/db.go reset

db-full:
	go run cmd/db.go full

db-seed:
	go run cmd/db.go seed

sqlc:
	sqlc generate
