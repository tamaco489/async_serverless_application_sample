resource "aws_secretsmanager_secret" "line_message_api" {
  name        = local.line_message_api_secret_id
  description = "LINE Message API"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-secret-manager"
  }
}

resource "aws_secretsmanager_secret_version" "line_message_api" {
  secret_id     = aws_secretsmanager_secret.line_message_api.id
  secret_string = jsonencode(data.sops_file.line_message_api_secret.data)
}
