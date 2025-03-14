#!/bin/bash

aws --endpoint-url http://localhost:8000 dynamodb create-table \
    --table-name player_profiles \
    --billing-mode PAY_PER_REQUEST \
    --attribute-definitions \
      AttributeName=player_id,AttributeType=N \
      AttributeName=paid_gem_balance,AttributeType=N \
      AttributeName=free_gem_balance,AttributeType=N \
      AttributeName=level,AttributeType=N \
      AttributeName=updated_at,AttributeType=S \
    --key-schema AttributeName=player_id,KeyType=HASH \
    --global-secondary-indexes '[
      {
        "IndexName": "PaidGemBalanceIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "paid_gem_balance", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "FreeGemBalanceIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "free_gem_balance", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "LevelIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "level", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      },
      {
        "IndexName": "UpdatedAtIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "updated_at", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"}
      }
    ]' | jq .
