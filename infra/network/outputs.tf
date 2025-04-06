output "vpc" {
  value = {
    arn                = aws_vpc.async_serverless_app.arn
    id                 = aws_vpc.async_serverless_app.id
    cidr_block         = aws_vpc.async_serverless_app.cidr_block
    public_subnet_ids  = [for s in aws_subnet.public_subnet : s.id]
    # private_subnet_ids = [for s in aws_subnet.private_subnet : s.id]
  }
}
