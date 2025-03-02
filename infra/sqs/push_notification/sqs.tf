resource "aws_sqs_queue" "push_notification_queue" {
  name = "${local.fqn}-queue"

  # 標準Queueとして定義（順序を考慮しない）
  fifo_queue = false

  # 最大メッセージサイズ
  max_message_size = local.queue_max_message_size

  # キューの可視性タイムアウト。秒単位で設定。（指定した期間中は他のコンシューマーはキューを参照することができない）
  visibility_timeout_seconds = local.queue_visibility_timeout_seconds

  # メッセージの保持時間、秒単位で設定
  message_retention_seconds = local.queue_message_retention_seconds

  # キュー内の全メッセージの配送を遅延させる時間、秒単位で設定。（30秒で設定した場合、キューに送信してもLambda30秒間はこのキューを見ることができない。※0の場合は即時配信となる）
  delay_seconds = 0

  # ロングポーリングの待機時間。秒単位で設定。（0の場合、即時レスポンスとなる）
  receive_wait_time_seconds = 0

  # SQSマネージドサーバーサイド暗号化（SSE）を有効にするかどうか
  sqs_managed_sse_enabled = false

  redrive_policy = jsonencode({
    # DLQのARNを指定
    deadLetterTargetArn = aws_sqs_queue.push_notification_dlq.arn

    # リトライ回数を5回に設定
    maxReceiveCount = local.max_receive_count
  })

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-queue"
  }
}

# DLQの設定
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
