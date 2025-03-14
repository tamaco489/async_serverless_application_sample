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

resource "aws_iam_role" "gem_api" {
  name               = "${local.fqn}-api-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_assume_role.json
  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-api"
  }
}

# https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
resource "aws_iam_role_policy_attachment" "gem_api_execution_role" {
  role       = aws_iam_role.gem_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# =================================================================
# dynamodb policy
# =================================================================
data "aws_iam_policy_document" "gem_api_dynamodb_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]
    resources = [
      "${aws_dynamodb_table.player_profiles.arn}",
      "${aws_dynamodb_table.transaction_histories.arn}",
    ]
  }
}

resource "aws_iam_policy" "gem_api_dynamodb_policy" {
  name        = "${local.fqn}-api-dynamodb-policy"
  description = "Allows API to interact with the player_profiles DynamoDB table"
  policy      = data.aws_iam_policy_document.gem_api_dynamodb_policy.json
}

resource "aws_iam_role_policy_attachment" "gem_api_dynamodb_role" {
  role       = aws_iam_role.gem_api.name
  policy_arn = aws_iam_policy.gem_api_dynamodb_policy.arn
}
