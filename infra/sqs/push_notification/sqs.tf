resource "aws_sqs_queue" "push_notification_queue" {
  name                       = "${local.fqn}-queue"
  fifo_queue                 = false
  max_message_size           = local.queue_max_message_size
  visibility_timeout_seconds = local.queue_visibility_timeout_seconds
  message_retention_seconds  = local.queue_message_retention_seconds
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = false

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.push_notification_dlq.arn
    maxReceiveCount     = local.max_receive_count
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
  max_message_size           = local.dlq_max_message_size
  visibility_timeout_seconds = local.dlq_visibility_timeout_seconds
  message_retention_seconds  = local.dlq_message_retention_seconds
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = false

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-dlq"
  }
}
