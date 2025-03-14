resource "aws_lambda_function" "slack_message_batch" {
  function_name = "${local.fqn}-batch"
  description   = "Slackメッセージ送信バッチ"
  role          = aws_iam_role.slack_message_batch.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.slack_message_batch.url}:slack_message_batch_v0.0.0"
  timeout       = 20
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.slack_message_batch.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      ENV          = "stg"
      SERVICE_NAME = "slack-message"
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}

# DynamoDB Stream機能を利用して、レコードの変更を監視し、変更があった場合にLambdaを起動するための設定
resource "aws_lambda_event_source_mapping" "dynamodb_stream" {
  enabled       = true
  function_name = aws_lambda_function.slack_message_batch.arn

  # NOTE: 注意点:
  # ここで指定するARNは対象のテーブルのARNではなく、DynamoDB StreamのARNを指定する必要がある。
  # また、StreamのARNはタイムスタンプを持っているため、Stream自身に更新があった場合はARNに差分が出てしまう。
  event_source_arn = data.terraform_remote_state.dynamodb.outputs.transaction_histories.stream_arn

  # DynamoDB Streams では、テーブルの変更履歴が 「shard」 と呼ばれるストリームに順番に記録されます。
  # このストリームからデータを取得する際、どの位置から処理を開始するかを starting_position で決める 必要があります。
  # "LATEST" を設定すると、DynamoDB の変更を検知し、ストリームの最新データ（直近の変更）から処理を開始 します。
  # より具体的には、過去の変更は無視 され、設定後に発生した変更のみを処理対象 とします。
  # "TRIM_HORIZON" を設定した場合は最も古いストリームデータから順番に処理 されます。※例) 過去1週間分のデータをすべて処理するようなバッチ処理に適しています。
  # DOC: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping.html#:~:text=starting_position%20%2D%20(Optional)%20The,API%20Reference.
  starting_position = "LATEST"

  # 一度に処理するイベント数
  # defaultは100、小さい値にする程リアルタイム性が向上する。※大きい値にした場合、大量のデータを一括で処理できるメリットもあるが、遅延が発生する可能性があります。
  batch_size = 10

  # Lambda が処理に失敗したときの「最大リトライ回数」を指定。
  # デフォルトは無制限 なので、エラー時に無限ループになるのを防ぐため に設定します。
  maximum_retry_attempts = 3

  # DynamoDB Streams に流れてきたレコードの「最大許容時間」を指定。
  # Lambda の処理遅延が発生すると、数分〜数時間前の古いデータが処理される可能性があります。
  # 例えば、Slack 通知を送る Lambda の場合、1時間前のイベントが突然通知される などの問題が発生します。
  # リアルタイム処理が目的の場合、不要な遅延データを処理しないようにするための対策として設定することが一般的。
  # 指定した秒数を超えた 古いレコードは Lambda で処理される前に破棄されるようになります。※以下は10分以上経過したデータは対象外としています。
  maximum_record_age_in_seconds = 600

  # DynamoDB Streams のshardごとに「並列実行」する Lambda 数を指定。
  # 各shardに1つの Lambda 関数しかアタッチされないのがデフォルト。※1シャードにつき1つの Lambda しか処理できない。
  # 1shardに対して 複数の Lambda を並列実行 できるようになり、最大 10 まで 設定が可能です。
  # 注意点として、shardを増やした場合順序が担保されないため、決済処理のようなAの処理が終わってBの処理を行う等の順序性を考慮するロジックの場合はシリアルに処理するのが一般的。
  # このプロダクトは検証利用を目的としているため、デフォルト値を設定しています。
  parallelization_factor = 1
}
