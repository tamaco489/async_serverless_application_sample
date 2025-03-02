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

resource "aws_iam_role" "push_notification_batch" {
  name               = "${local.fqn}-batch-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role.json
  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-batch"
  }
}

# https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
resource "aws_iam_role_policy_attachment" "push_notification_batch_execution_role" {
  role       = aws_iam_role.push_notification_batch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# =================================================================
# sqs iam policy
# =================================================================
data "aws_iam_policy_document" "push_notification_batch_sqs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      data.terraform_remote_state.sqs.outputs.push_notification_queue.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      data.terraform_remote_state.sqs.outputs.push_notification_dlq.arn
    ]
  }
}

# SQSへのアクセス権を定義するポリシードキュメントをIAM Policyとして定義し、IAM Roleに関連付ける
resource "aws_iam_policy" "push_notification_batch_sqs_policy" {
  name        = "${local.fqn}-batch-sqs-policy"
  description = "policy to allow lambdas to retrieve queued data"
  policy      = data.aws_iam_policy_document.push_notification_batch_sqs_policy.json
}

resource "aws_iam_role_policy_attachment" "push_notification_batch_sqs_role" {
  role       = aws_iam_role.push_notification_batch.name
  policy_arn = aws_iam_policy.push_notification_batch_sqs_policy.arn
}
