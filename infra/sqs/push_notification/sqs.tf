resource "aws_sqs_queue" "push_notification_queue" {
  name                       = "${local.fqn}-queue"
  fifo_queue                 = false
  max_message_size           = 256 * 1024       # 256KB
  visibility_timeout_seconds = 15 * 60          # 15分（900秒）
  message_retention_seconds  = 4 * 24 * 60 * 60 # 4日間（345600秒）
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = false

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.push_notification_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-queue"
  }
}

resource "aws_sqs_queue" "push_notification_dlq" {
  name                       = "${local.fqn}-dlq"
  fifo_queue                 = false
  max_message_size           = 256 * 1024       # 256KB
  visibility_timeout_seconds = 15 * 60          # 15分（900秒）
  message_retention_seconds  = 7 * 24 * 60 * 60 # 7日間（604800秒）
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = false

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-dlq"
  }
}
