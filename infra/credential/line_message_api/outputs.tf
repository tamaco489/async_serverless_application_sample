output "line_message_api" {
  value = {
    name = aws_secretsmanager_secret.line_message_api.name
    arn  = aws_secretsmanager_secret.line_message_api.arn
  }
}
