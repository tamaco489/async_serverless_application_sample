resource "aws_lambda_function" "push_notification_batch" {
  function_name = "${local.fqn}-batch"
  description   = "プッシュ通知バッチ"
  role          = aws_iam_role.push_notification_batch.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.push_notification_batch.url}:push_notification_batch_v0.0.0"
  timeout       = 20
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.push_notification_batch.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
    # subnet_ids                = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids # NOTE: NAT使いたくないのでプライベートサブネットは使わない
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      ENV          = "stg"
      SERVICE_NAME = "push-notification"
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}

# Lambdaのイベントソースマッピングの設定
# SQSキューからのメッセージ受信をトリガーに、Lambadaを起動するために必要な設定
resource "aws_lambda_event_source_mapping" "push_notification_batch" {
  event_source_arn = data.terraform_remote_state.sqs.outputs.push_notification_queue.arn
  function_name    = aws_lambda_function.push_notification_batch.function_name

  # Queueのトリガー設定を有効化
  enabled = true

  # Lambdaは20秒間待機し、その間に最大5件のメッセージを集める
  # 待機時間が経過する前に5件集まった場合即座に処理を開始するが、20秒経過したら集まったメッセージ数に関わらず処理が始まる
  maximum_batching_window_in_seconds = 20
  batch_size                         = 5

  # 送信されるメッセージにおけるフィルター処理を定義することができる
  # DLQへの受け渡しの挙動を検証したいためフィルタリング設定は無効化する
  # filter_criteria {
  #   filter {
  #     pattern = jsonencode({
  #       body = {
  #         status = ["COMPLETED"] # "status"が"COMPLETED"の場合にのみトリガー
  #       }
  #     })
  #   }
  # }
}
