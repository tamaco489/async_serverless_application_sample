output "player_profiles" {
  value = {
    id   = aws_dynamodb_table.player_profiles.id
    arn  = aws_dynamodb_table.player_profiles.arn
    name = aws_dynamodb_table.player_profiles.name
  }
}

output "transaction_histories" {
  value = {
    id   = aws_dynamodb_table.transaction_histories.id
    arn  = aws_dynamodb_table.transaction_histories.arn
    name = aws_dynamodb_table.transaction_histories.name
  }
}
