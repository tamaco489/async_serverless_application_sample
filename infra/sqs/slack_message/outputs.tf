output "slack_message_dlq" {
  value = {
    id  = aws_sqs_queue.slack_message_dlq.id,
    arn = aws_sqs_queue.slack_message_dlq.arn
  }
}
