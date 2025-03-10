#!/bin/bash

aws --endpoint-url http://localhost:8000 dynamodb create-table \
    --table-name player_profiles \
    --attribute-definitions \
        AttributeName=player_id,AttributeType=S \
        AttributeName=paid_gem_balance,AttributeType=N \
        AttributeName=free_gem_balance,AttributeType=N \
        AttributeName=level,AttributeType=N \
        AttributeName=play_time,AttributeType=N \
        AttributeName=last_login,AttributeType=S \
    --key-schema AttributeName=player_id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --global-secondary-indexes '[
      {
        "IndexName": "PaidGemBalanceIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "paid_gem_balance", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"},
        "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
      },
      {
        "IndexName": "FreeGemBalanceIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "free_gem_balance", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"},
        "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
      },
      {
        "IndexName": "LevelIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "level", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"},
        "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
      },
      {
        "IndexName": "PlayTimeIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "play_time", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"},
        "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
      },
      {
        "IndexName": "LastLoginIndex",
        "KeySchema": [
          {"AttributeName": "player_id", "KeyType": "HASH"},
          {"AttributeName": "last_login", "KeyType": "RANGE"}
        ],
        "Projection": {"ProjectionType": "ALL"},
        "ProvisionedThroughput": {"ReadCapacityUnits": 5, "WriteCapacityUnits": 5}
      }
    ]' | jq .
