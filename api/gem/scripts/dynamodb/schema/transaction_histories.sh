aws --endpoint-url http://localhost:8000 dynamodb create-table \
    --table-name transaction_histories \
    --billing-mode PAY_PER_REQUEST \
    --attribute-definitions \
      AttributeName=transaction_id,AttributeType=S \
      AttributeName=timestamp,AttributeType=S \
      AttributeName=player_id,AttributeType=N \
      AttributeName=transaction_type,AttributeType=S \
      AttributeName=gem_id,AttributeType=N \
      AttributeName=paid_gem_quantity,AttributeType=N \
      AttributeName=free_gem_quantity,AttributeType=N \
    --key-schema \
      AttributeName=player_id,KeyType=HASH \
      AttributeName=timestamp,KeyType=RANGE \
    --local-secondary-indexes '[
      {
        "IndexName": "PlayerTimestampIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "timestamp", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "PlayerTransactionTypeIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "transaction_type", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      }
    ]' \
    --global-secondary-indexes '[
      {
        "IndexName": "TransactionIDIndex",
        "KeySchema": [
          {"AttributeName": "transaction_id", "KeyType": "HASH"},
          {"AttributeName": "player_id", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "GemTransactionsIndex",
        "KeySchema": [
          {"AttributeName": "gem_id", "KeyType": "HASH"},
          {"AttributeName": "player_id", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "PaidGemQuantityIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "paid_gem_quantity", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "FreeGemQuantityIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "free_gem_quantity", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      }
    ]' | jq .
