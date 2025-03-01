resource "aws_vpc" "async_serverless_app" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}"
  }
}
