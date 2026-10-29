
resource "aws_security_group" "vpc_link" {
  name_prefix = "${var.name_prefix}-vpclink-"
  description = "API Gateway REST API VPC Link V2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-vpclink-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.vpc_link.id

  description = "HTTP traffic to private NLB"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = var.vpc_cidr
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.name_prefix}-vpclink"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_link.id]

  tags = {
    Name = "${var.name_prefix}-vpclink"
  }
}
data "aws_lb" "internal" {
  name = var.nlb_name
}
