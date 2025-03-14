resource "aws_dynamodb_table" "player_profiles" {
  name         = "player_profiles"
  billing_mode = "PAY_PER_REQUEST"
  table_class  = "STANDARD"
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
  }
}
