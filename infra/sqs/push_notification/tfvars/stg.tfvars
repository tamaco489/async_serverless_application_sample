env       = "stg"
project   = "async-serverless-app"
feature   = "push-notification"

queue_config = {
  max_message_size_kb        = 256
  visibility_timeout_minutes = 15
  message_retention_days     = 4
  max_receive_count          = 5
}

dlq_config = {
  max_message_size_kb        = 256
  visibility_timeout_minutes = 15
  message_retention_days     = 7
}
