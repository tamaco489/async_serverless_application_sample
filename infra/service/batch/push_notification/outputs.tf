output "push_notification_batch_security_group" {
  description = "Security Group details for the push_notification_batch Lambda"
  value = {
    id          = aws_security_group.push_notification_batch.id
    name        = aws_security_group.push_notification_batch.name
    arn         = aws_security_group.push_notification_batch.arn
    description = aws_security_group.push_notification_batch.description
  }
}
