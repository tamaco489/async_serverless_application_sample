resource "aws_route53_zone" "async_serverless_app" {
  name    = var.domain
  comment = "非同期処理の検証で利用"
  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}"
  }
}
