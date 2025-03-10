resource "aws_apigatewayv2_api" "gem_api" {
  name          = "${local.fqn}-api"
  description   = "通貨API"
  protocol_type = "HTTP"

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-api"
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.gem_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.gem_api.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "gem_api_route" {
  api_id    = aws_apigatewayv2_api.gem_api.id
  route_key = "ANY /gem/v2/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.gem_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "coral_api_mapping" {
  api_id      = aws_apigatewayv2_api.gem_api.id
  domain_name = data.terraform_remote_state.acm.outputs.gem_apigatewayv2_domain_name.id
  stage       = aws_apigatewayv2_stage.default_stage.id
}
