resource "aws_lambda_function" "gem_api" {
  function_name = "${local.fqn}-api"
  description   = "通貨API"
  role          = aws_iam_role.gem_api.arn
  package_type  = "Image"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.gem_api.url}:gem_api_v0.0.0"
  timeout       = 20
  memory_size   = 128

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.gem_api.id]
    subnet_ids                  = data.terraform_remote_state.network.outputs.vpc.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      API_SERVICE_NAME = "gem-api"
      API_ENV          = "stg"
      API_PORT         = "8080"
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
  function_name = aws_lambda_function.gem_api.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gem_api.execution_arn}/*/*"
}
