# VPC エンドポイント用のセキュリティグループの作成
resource "aws_security_group" "shop_api_sqs_vpc_endpoint" {
  name        = "${local.fqn}-shop-api-sqs-${var.feature}-sg"
  description = "Allow SQS VPC endpoint for VPC Lambda"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-shop-api-sqs-${var.feature}-sg"
  }
}

# # Lambda 用セキュリティグループ（shop_api）から SQS VPC エンドポイントのセキュリティグループへの HTTPS（443番ポート）アクセスを許可
resource "aws_vpc_security_group_ingress_rule" "allow_https_from_lambda" {
  security_group_id            = aws_security_group.shop_api_sqs_vpc_endpoint.id
  description                  = "Allow Push Shop API Lambda SG to access SQS VPC Endpoint"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.shop_api_service.outputs.shop_api_security_group.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-shop-api-sqs-${var.feature}-ingress-sg"
  }
}

# VPC エンドポイント用のセキュリティグループの作成
resource "aws_security_group" "push_notification_batch_sqs_vpc_endpoint" {
  name        = "${local.fqn}-push-notification-batch-sqs-${var.feature}-sg"
  description = "Allow SQS VPC endpoint for Push Notification Batch Lambda"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-push-notification-batch-sqs-${var.feature}-sg"
  }
}

# # Lambda 用セキュリティグループ（shop_api）から SQS VPC エンドポイントのセキュリティグループへの HTTPS（443番ポート）アクセスを許可
resource "aws_vpc_security_group_ingress_rule" "allow_https_from_batch_lambda" {
  security_group_id            = aws_security_group.push_notification_batch_sqs_vpc_endpoint.id
  description                  = "Allow Push Notification Batch Lambda SG to access SQS VPC Endpoint"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = data.terraform_remote_state.batch_push_notification_service.outputs.push_notification_batch_security_group.id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-push-notification-batch-sqs-${var.feature}-ingress-sg"
  }
}
