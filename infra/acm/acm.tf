resource "aws_acm_certificate" "async_serverless_app" {
  domain_name               = "*.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  subject_alternative_names = [data.terraform_remote_state.route53.outputs.host_zone.name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}"
  }
}

# =======================================================
# shop api
# =======================================================
resource "aws_apigatewayv2_domain_name" "shop_api_v1" {
  domain_name = "apiv1.${data.terraform_remote_state.route53.outputs.host_zone.name}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.async_serverless_app.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "shop_api_v1" {
  zone_id = data.terraform_remote_state.route53.outputs.host_zone.id
  name    = "apiv1.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.shop_api_v1.domain_name_configuration.0.target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.shop_api_v1.domain_name_configuration.0.hosted_zone_id
    evaluate_target_health = false
  }
}

# =======================================================
# gem api
# =======================================================
resource "aws_apigatewayv2_domain_name" "gem_api_v2" {
  domain_name = "apiv2.${data.terraform_remote_state.route53.outputs.host_zone.name}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.async_serverless_app.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "gem_api_v2" {
  zone_id = data.terraform_remote_state.route53.outputs.host_zone.id
  name    = "apiv2.${data.terraform_remote_state.route53.outputs.host_zone.name}"
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.gem_api_v2.domain_name_configuration.0.target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.gem_api_v2.domain_name_configuration.0.hosted_zone_id
    evaluate_target_health = false
  }
}
