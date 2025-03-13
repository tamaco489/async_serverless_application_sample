aws --endpoint-url http://localhost:8000 dynamodb create-table \
    --table-name transaction_histories \
    --attribute-definitions \
        AttributeName=transaction_id,AttributeType=S \
        AttributeName=timestamp,AttributeType=S \
        AttributeName=player_id,AttributeType=S \
        AttributeName=transaction_type,AttributeType=S \
        AttributeName=gem_id,AttributeType=N \
        AttributeName=paid_gem_quantity,AttributeType=N \
        AttributeName=free_gem_quantity,AttributeType=N \
    --key-schema AttributeName=transaction_id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --global-secondary-indexes '[
        {
            "IndexName": "PlayerTransactionsIndex",
            "KeySchema": [
                {"AttributeName": "player_id", "KeyType": "HASH"},
                {"AttributeName": "timestamp", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "TransactionTypeIndex",
            "KeySchema": [
                {"AttributeName": "player_id", "KeyType": "HASH"},
                {"AttributeName": "transaction_type", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "GemTransactionsIndex",
            "KeySchema": [
                {"AttributeName": "player_id", "KeyType": "HASH"},
                {"AttributeName": "gem_id", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "PaidGemQuantityIndex",
            "KeySchema": [
                {"AttributeName": "player_id", "KeyType": "HASH"},
                {"AttributeName": "paid_gem_quantity", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        },
        {
            "IndexName": "FreeGemQuantityIndex",
            "KeySchema": [
                {"AttributeName": "player_id", "KeyType": "HASH"},
                {"AttributeName": "free_gem_quantity", "KeyType": "RANGE"}
            ],
            "Projection": {"ProjectionType": "ALL"},
            "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
        }
    ]' | jq .