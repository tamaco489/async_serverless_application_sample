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
# dynamodb コンテナ起動したり、テーブル作成したり、削除したりするやつ
# =================================================================
# コンテナの操作
.PHONY: dynamodb-up dynamodb-down dynamodb-logs
dynamodb-up:
	docker compose up -d dynamodb-local dynamodb-admin

dynamodb-down:
	docker compose down dynamodb-local dynamodb-admin

dynamodb-logs:
	docker compose logs -f dynamodb-local


# テーブル操作
.PHONY: get-tables get-user-info-table get-transaction-histories-table create-tables delete-tables
get-tables:
	aws --endpoint-url http://localhost:8000 dynamodb list-tables | jq .

get-user-info-table:
	aws --endpoint-url http://localhost:8000 dynamodb describe-table --table-name player_profiles | jq .

get-transaction-histories-table:
	aws --endpoint-url http://localhost:8000 dynamodb describe-table --table-name transaction_histories | jq .

create-tables:
	sh -exv scripts/dynamodb/schema/player_profiles.sh
	sh -exv scripts/dynamodb/schema/transaction_histories.sh

delete-tables:
	aws --endpoint-url http://localhost:8000 dynamodb delete-table --table-name player_profiles | jq .
	aws --endpoint-url http://localhost:8000 dynamodb delete-table --table-name transaction_histories | jq .


# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
VERSION := gem_api_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-gem-api:$(VERSION) -f ./build/Dockerfile.gem .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-gem-api:$(VERSION)

get-images:
	aws ecr list-images --repository-name stg-gem-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
	@aws ecr list-images --repository-name stg-gem-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name stg-gem-api --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

# lambda
.PHONY: deploy
deploy: push
	aws lambda update-function-code  --profile ${AWS_PROFILE} \
		--function-name stg-gem-api \
		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-gem-api:$(VERSION) | jq .


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
		'http://localhost:8081/gem/v2/healthcheck' \
		-H 'accept: application/json'
	@echo

# 通貨系API
.PHONY: get-gem-balance update-gem-purchase
get-gem-balance:
	curl -i -X 'GET' \
		'http://localhost:8081/gem/v2/currencies/balances' \
		-H 'accept: application/json'
	@echo

update-gem-purchase:
	curl -i -X 'PUT' \
		'http://localhost:8081/gem/v2/currencies/purchases' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"gem_id": 10001010,"quantity": 1000}'
	@echo

# =================================================================
# apiリクエストする時用のやつ（stg）
# =================================================================
AWS_API_v2_DOMAIN := <api.domain>

stg-api-all-request: stg-healthcheck sleep \
	stg-get-gem-balance sleep \
	stg-update-gem-purchase sleep

.PHONY: stg-healthcheck
stg-healthcheck:
	curl -i -X 'GET' \
		'https://${AWS_API_v2_DOMAIN}/gem/v2/healthcheck' \
		-H 'accept: application/json'

.PHONY: stg-get-gem-balance stg-update-gem-purchase
stg-get-gem-balance:
	curl -i -X 'GET' \
		'https://${AWS_API_v2_DOMAIN}/gem/v2/currencies/balances' \
		-H 'accept: application/json'
	@echo

stg-update-gem-purchase:
	curl -i -X 'PUT' \
		'https://${AWS_API_v2_DOMAIN}/gem/v2/currencies/purchases' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"gem_id": 10001010,"quantity": 1000}'
	@echo
