output "push_notification_queue" {
  value = {
    id  = aws_sqs_queue.push_notification_queue.id,
    arn = aws_sqs_queue.push_notification_queue.arn
  }
}

output "push_notification_dlq" {
  value = {
    id  = aws_sqs_queue.push_notification_dlq.id,
    arn = aws_sqs_queue.push_notification_dlq.arn
  }
}
