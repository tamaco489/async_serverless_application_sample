data "aws_iam_policy_document" "lambda_execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "slack_message_batch" {
  name               = "${local.fqn}-batch-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role.json
  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}

# DOC: https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
resource "aws_iam_role_policy_attachment" "slack_message_batch_execution_role" {
  role       = aws_iam_role.slack_message_batch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# =================================================================
# dynamodb policy
# =================================================================
data "aws_iam_policy_document" "slack_message_batch_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams"
    ]
    resources = [
      # NOTE: 注意点として、ここで指定するARNは対象のテーブルのARNではなく、DynamoDB StreamのARNを指定する必要がある。
      data.terraform_remote_state.dynamodb.outputs.transaction_histories.stream_arn
    ]
  }
}

resource "aws_iam_policy" "slack_message_batch_policy" {
  name        = "${local.fqn}-batch-dynamodb-policy"
  description = "Allows Batch Lambda to read from the transaction_histories DynamoDB Stream"
  policy      = data.aws_iam_policy_document.slack_message_batch_policy.json
}

resource "aws_iam_role_policy_attachment" "slack_message_batch_role" {
  role       = aws_iam_role.slack_message_batch.name
  policy_arn = aws_iam_policy.slack_message_batch_policy.arn
}