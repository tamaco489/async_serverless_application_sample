# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
VERSION := slack_message_batch_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-slack-message-batch:$(VERSION) -f ./build/Dockerfile.slack_message .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-slack-message-batch:$(VERSION)

get-images:
	aws ecr list-images --repository-name stg-slack-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
	@aws ecr list-images --repository-name stg-slack-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name stg-slack-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

# lambda
# .PHONY: deploy
# deploy: push
# 	aws lambda update-function-code  --profile ${AWS_PROFILE} \
# 		--function-name stg-slack-message-batch \
# 		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-slack-message-batch:$(VERSION) | jq .
