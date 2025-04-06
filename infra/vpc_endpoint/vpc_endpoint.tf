# NOTE: NAT使わない場合は必要な設定。VPC LambdaはENIを持っていないので外部へ通信できない（SQSへアクセスできない）ので、SQS VPCエンドポイントを用意し、それ経由でインターネット上にアクセスする
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc.id
  service_name        = "com.amazonaws.ap-northeast-1.sqs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids # エンドポイントに関連付けるセキュリティグループ
  security_group_ids  = [
    aws_security_group.shop_api_sqs_vpc_endpoint.id,
    aws_security_group.push_notification_batch_sqs_vpc_endpoint.id,
  ]                 # プライベートDNSを有効にすることで、内部DNSでアクセス可能に
  private_dns_enabled = true
  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${local.fqn}-sqs-${var.feature}"
  }
}
