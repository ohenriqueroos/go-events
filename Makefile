build:
	@echo "Compilando Go para Linux (AL2023)..."
	@# O nome do binário DEVE ser 'bootstrap' para provided.al2023
	GOOS=linux GOARCH=amd64 go build -o bin/bootstrap cmd/ingest/main.go

deploy: build
	@echo "Deploying com OpenTofu..."
	cd infra && tofu init && tofu apply -auto-approve

destroy:
	cd infra && tofu destroy -auto-approve
