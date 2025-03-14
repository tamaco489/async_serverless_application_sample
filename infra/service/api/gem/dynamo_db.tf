# =================================================================
# player_profiles
# =================================================================
resource "aws_dynamodb_table" "player_profiles" {
  name         = "player_profiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "player_id"

  attribute {
    name = "player_id"
    type = "N"
  }

  attribute {
    name = "paid_gem_balance"
    type = "N"
  }

  attribute {
    name = "free_gem_balance"
    type = "N"
  }

  attribute {
    name = "level"
    type = "N"
  }

  attribute {
    name = "updated_at"
    type = "S"
  }

  global_secondary_index {
    name            = "PaidGemBalanceIndex"
    hash_key        = "player_id"
    range_key       = "paid_gem_balance"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "FreeGemBalanceIndex"
    hash_key        = "player_id"
    range_key       = "free_gem_balance"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "LevelIndex"
    hash_key        = "player_id"
    range_key       = "level"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "UpdatedAtIndex"
    hash_key        = "player_id"
    range_key       = "updated_at"
    projection_type = "ALL"
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}-player-profiles"
  }
}

# =================================================================
# transaction_histories
# =================================================================
resource "aws_dynamodb_table" "transaction_histories" {
  name         = "transaction_histories"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "player_id"
  range_key = "timestamp"

  attribute {
    name = "transaction_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  attribute {
    name = "player_id"
    type = "N"
  }

  attribute {
    name = "transaction_type"
    type = "S"
  }

  attribute {
    name = "gem_id"
    type = "N"
  }

  attribute {
    name = "paid_gem_quantity"
    type = "N"
  }

  attribute {
    name = "free_gem_quantity"
    type = "N"
  }

  local_secondary_index {
    name            = "PlayerTimestampIndex"
    range_key       = "timestamp"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "PlayerTransactionTypeIndex"
    range_key       = "transaction_type"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "TransactionIDIndex"
    hash_key        = "transaction_id"
    range_key       = "player_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "GemTransactionsIndex"
    hash_key        = "gem_id"
    range_key       = "player_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "PaidGemQuantityIndex"
    hash_key        = "player_id"
    range_key       = "paid_gem_quantity"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "FreeGemQuantityIndex"
    hash_key        = "player_id"
    range_key       = "free_gem_quantity"
    projection_type = "ALL"
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}-transaction-histories"
  }
}

