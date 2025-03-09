# =================================================================
# 実行環境設定する時用のやつ
# =================================================================
.PHONY: setup-env install-tools
setup-env:
	cp -p .env_sample .env

install-tools: setup-env
	go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest
	go install golang.org/x/tools/cmd/godoc@latest
	npm i -g @redocly/cli@latest


.PHONY: gen-api bundle-openapi
gen-api: bundle-openapi
	oapi-codegen -package gen -generate types -o internal/gen/types.gen.go ./spec/openapi.yaml
	oapi-codegen -package gen -generate strict-server,gin -templates ./spec/templates -o internal/gen/server.gen.go ./spec/openapi.yaml

bundle-openapi:
	redocly bundle ./spec/openapi_base.yaml --output ./spec/openapi.yaml


# =================================================================
# ローカル起動する時用のやつ
# =================================================================
.PHONY: lint deps build run
lint:
	golangci-lint run --timeout 3m

deps:
	go mod download && go mod tidy

build: deps
	go build -o build/gem_api cmd/main.go

run: build
	./build/gem_api


# =================================================================
# コンテナ起動する時用のやつ
# =================================================================
.PHONY: up down logs
up:
	docker compose up -d gem-api

down:
	docker compose down gem-api

logs:
	docker compose logs -f gem-api


# =================================================================
# dynamodb コンテナ起動したりするやつ
# =================================================================
.PHONY: dynamodb-up dynamodb-down dynamodb-logs
dynamodb-up:
	docker compose up -d dynamodb-local dynamodb-admin

dynamodb-down:
	docker compose down dynamodb-local dynamodb-admin

dynamodb-logs:
	docker compose logs -f dynamodb-local


# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
VERSION := gem_api_v0.0.0


# =================================================================
# apiリクエストする時用のやつ（dev）
# =================================================================
.PHONY: api-all-request
sleep:
	@sleep 0.5

api-all-request: healthcheck sleep \
	get-gem-balance sleep \
	update-gem-purchase sleep

.PHONY: healthcheck
healthcheck:
	curl -i -X 'GET' \
		'http://localhost:8081/gem/v1/healthcheck' \
		-H 'accept: application/json'
	@echo

# 通貨系API
.PHONY: get-gem-balance update-gem-purchase
get-gem-balance:
	curl -i -X 'GET' \
		'http://localhost:8081/gem/v1/currencies/balances' \
		-H 'accept: application/json'
	@echo

update-gem-purchase:
	curl -i -X 'PUT' \
		'http://localhost:8081/gem/v1/currencies/purchases' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"gem_id": 10001010,"quantity": 1000}'
	@echo
