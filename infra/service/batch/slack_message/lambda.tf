resource "aws_lambda_function" "slack_message_batch" {
  function_name = "${local.fqn}-batch"
  description   = "Slackメッセージ送信バッチ"
  role          = aws_iam_role.slack_message_batch.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.slack_message_batch.url}:slack_message_batch_v0.0.0"
  timeout       = 20
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.slack_message_batch.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      ENV          = "stg"
      SERVICE_NAME = "slack-message"
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}
