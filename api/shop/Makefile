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
	go build -o build/shop_api cmd/main.go

run: build
	./build/shop_api


# =================================================================
# コンテナ起動する時用のやつ
# =================================================================
.PHONY: up down logs
up:
	docker compose up -d shop-api

down:
	docker compose down shop-api

logs:
	docker compose logs -f shop-api


# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
VERSION := shop_api_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/dev-shop-api:$(VERSION) -f ./build/Dockerfile.shop .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/dev-shop-api:$(VERSION)

get-images:
	aws ecr list-images --repository-name dev-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
	@aws ecr list-images --repository-name dev-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name dev-shop-api --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

# lambda
.PHONY: deploy
deploy: push
	aws lambda update-function-code  --profile ${AWS_PROFILE} \
		--function-name dev-shop-api \
		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/dev-shop-api:$(VERSION) | jq .


# =================================================================
# apiリクエストする時用のやつ
# =================================================================
.PHONY: api-all-request
sleep:
	@sleep 0.5

api-all-request: healthcheck sleep \
	create-user sleep \
	get-me sleep \
	create-profile sleep \
	get-profile-me sleep \
	get-products sleep \
	get-product-by-id sleep \
	get-credit-cards sleep \
	create-credit-card sleep \
	delete-credit-card sleep \
	create-reservations sleep \
	create-charge sleep \
	get-charge-histories sleep \
	get-customer sleep \
	create-customer sleep \
	delete-customer sleep

.PHONY: healthcheck
healthcheck:
	curl -i -X 'GET' \
		'http://localhost:8080/shop/v1/healthcheck' \
		-H 'accept: application/json'

# ユーザ系API
.PHONY: create-user get-me create-profile get-profile-me
create-user:
	curl -i -X 'POST' \
		'http://localhost:8080/shop/v1/users' \
		-H 'accept: application/json' \
		-d ''

get-me:
	curl -i -X 'GET' \
		'http://localhost:8080/shop/v1/users/me' \
		-H 'accept: application/json'

create-profile:
	curl -sX 'POST' \
		'http://localhost:8080/shop/v1/users/profiles' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"name": {"first_name": "智","last_name": "真皿","first_name_roman": "Satoshi","last_name_roman": "Masara"}, "address": { "region": "関東", "zip_code": "150-8377", "prefecture": "東京都", "city": "渋谷区", "street": "宇田川町", "other": "15番1号"}, "birthdate": "2000-01-01", "image_url": "https://example"}' | jq .

get-profile-me:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/users/profiles/me' \
		-H 'accept: application/json' | jq .

# 商品系API
.PHONY: get-products get-product-by-id
get-products:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/products?cursor=MjAwMDEwMDE%3D&limit=10' \
		-H 'accept: application/json' | jq .

get-product-by-id:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/products/20001001' \
		-H 'accept: application/json' | jq .

# 外部決済サービス向け顧客情報系API
.PHONY: get-customer create-customer delete-customer
get-customer:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/payment/customers/10001001' \
		-H 'accept: application/json' | jq .

create-customer:
	curl -i -sX 'POST' \
		'http://localhost:8080/shop/v1/payment/customers' \
		-H 'accept: application/json' \
		-d ''

delete-customer:
	curl -i -sX 'DELETE' \
		'http://localhost:8080/shop/v1/payment/customers' \
		-H 'accept: */*'

# カード系API
.PHONY: get-credit-cards create-credit-card delete-credit-card
get-credit-cards:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/payments/cards' \
		-H 'accept: application/json' | jq .

create-credit-card:
	curl -i -sX 'POST' \
		'http://localhost:8080/shop/v1/payments/cards' \
		-H 'accept: */*' \
		-H 'Content-Type: application/json' \
		-d '{"token": "9f9213b2-9687-6910-d2ec-3a247582be2d", "is_default": true}'

delete-credit-card:
	curl -i -sX 'DELETE' \
		'http://localhost:8080/shop/v1/payments/cards' \
		-H 'accept: */*'

# 予約系API
.PHONY: create-reservations
create-reservations:
	curl -i -sX 'POST' \
		'http://localhost:8080/shop/v1/payments/reservations' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '[{"product_id": 10001001, "quantity": 2}, {"product_id": 10001002, "quantity": 3}]'

# 注文系API
.PHONY: create-charge get-charge-histories
create-charge:
	curl -i -sX 'POST' \
		'http://localhost:8080/shop/v1/payments/charges' \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-d '{"reservation_id": "9f9213b2-9687-6910-d2ec-3a247582be2d"}'

get-charge-histories:
	curl -sX 'GET' \
		'http://localhost:8080/shop/v1/payments/charges/histories?offset=0&limit=10' \
		-H 'accept: application/json' | jq .
