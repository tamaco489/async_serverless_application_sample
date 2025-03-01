# resource "aws_internet_gateway" "async_serverless_app" {
#   vpc_id = aws_vpc.async_serverless_app.id

#   tags = {
#     Env     = var.env
#     Project = var.project
#     Name    = "${var.env}-${var.project}-internet-gw"
#   }
# }

resource "aws_nat_gateway" "async_serverless_app" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.private_subnet["a"].id

  tags = {
    Env     = var.env
    Project = var.project
    Name    = "${var.env}-${var.project}-nat-gw"
  }
}
