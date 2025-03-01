output "host_zone" {
  value = {
    id   = aws_route53_zone.async_serverless_app.id,
    name = aws_route53_zone.async_serverless_app.name
  }
}
