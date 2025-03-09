#!/bin/bash

aws --endpoint-url http://localhost:8000 dynamodb create-table \
    --table-name transaction_histories \
    --attribute-definitions \
        AttributeName=transaction_id,AttributeType=S \
        AttributeName=timestamp,AttributeType=N \
        AttributeName=user_id,AttributeType=S \
        AttributeName=transaction_type,AttributeType=S \
        AttributeName=gem_id,AttributeType=S \
        AttributeName=paid_gem_amount,AttributeType=N \
        AttributeName=free_gem_amount,AttributeType=N \
        AttributeName=description,AttributeType=S \
    --key-schema AttributeName=transaction_id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --global-secondary-indexes '[
        {
            "IndexName": "UserTransactionsIndex",
            "KeySchema": [
                {"AttributeName": "user_id", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "TransactionTypeIndex",
            "KeySchema": [
                {"AttributeName": "transaction_type", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "GemTransactionsIndex",
            "KeySchema": [
                {"AttributeName": "gem_id", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "PaidGemAmountIndex",
            "KeySchema": [
                {"AttributeName": "paid_gem_amount", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "FreeGemAmountIndex",
            "KeySchema": [
                {"AttributeName": "free_gem_amount", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "DescriptionIndex",
            "KeySchema": [
                {"AttributeName": "description", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        }
    ]' | jq .
