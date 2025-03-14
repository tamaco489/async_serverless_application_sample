resource "aws_cloudwatch_log_group" "slack_message_batch" {
  name              = "/aws/lambda/${aws_lambda_function.slack_message_batch.function_name}"
  retention_in_days = 3

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}
