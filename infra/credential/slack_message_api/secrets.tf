resource "aws_secretsmanager_secret" "slack_message_api" {
  name        = local.slack_message_api_secret_id
  description = "Slack Message API"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-secret-manager"
  }
}

resource "aws_secretsmanager_secret_version" "slack_message_api" {
  secret_id     = aws_secretsmanager_secret.slack_message_api.id
  secret_string = jsonencode(data.sops_file.slack_message_api_secret.data)
}
