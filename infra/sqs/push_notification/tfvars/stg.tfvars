env       = "stg"
project   = "async-serverless-app"
feature   = "push-notification"

queue_config = {
  max_message_size_kb        = 256
  visibility_timeout_minutes = 5 # 可視性タイムアウトの時間（分）
  message_retention_days     = 4 # メッセージの保持期間（日）
  max_receive_count          = 3 # リトライ回数
}

dlq_config = {
  max_message_size_kb        = 256
  visibility_timeout_minutes = 5
  message_retention_days     = 7
}
