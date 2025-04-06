resource "aws_lambda_function" "shop_api" {
  function_name = "${local.fqn}-api"
  description   = "ショップAPI"
  role          = aws_iam_role.shop_api.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.shop_api.url}:shop_api_v0.0.0"
  timeout       = 60
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.shop_api.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids
    # subnet_ids                = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids # NOTE: NAT使いたくないのでプライベートサブネットは使わない
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      API_SERVICE_NAME          = "shop-api"
      API_ENV                   = "stg"
      API_PORT                  = "8080"
      SQS_PUSH_NOTIFICATION_URL = data.terraform_remote_state.sqs.outputs.push_notification_queue.id
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-api"
  }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shop_api.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.shop_api.execution_arn}/*/*"
}
