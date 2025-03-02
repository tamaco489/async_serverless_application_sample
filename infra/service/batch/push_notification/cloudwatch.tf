resource "aws_cloudwatch_log_group" "push_notification_batch" {
  name              = "/aws/lambda/${aws_lambda_function.push_notification_batch.function_name}"
  retention_in_days = 3

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}
