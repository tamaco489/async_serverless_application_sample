output "shop_api_security_group" {
  description = "Security Group details for the shop_api Lambda"
  value = {
    id          = aws_security_group.shop_api.id
    name        = aws_security_group.shop_api.name
    arn         = aws_security_group.shop_api.arn
    description = aws_security_group.shop_api.description
  }
}
