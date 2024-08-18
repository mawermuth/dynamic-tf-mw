###
# Public Security Group
##

resource "aws_security_group" "public" {
  name        = "public-sg-${var.infra_env}"
  description = "Public internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name            = "public-sg-${var.infra_env}"
    Role            = "public"
    Project         = "dynamic-tf"
    Environment     = var.infra_env
    ManagedBy       = "terraform"
    auto_remediated = "CC-RemovedPublicIngress"
  }

  ingress {
    description = "HTTP TCP to 3000 port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  ingress {
    description     = "HTTPS TCP to 443 port"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-3b927c52"]
  }

  ingress {
    description = "HTTPS TCP to 443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS TCP to 443 port"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

# resource "aws_security_group_rule" "public_in_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public.id
# }

###
# Private Security Group
##

resource "aws_security_group" "private" {
  name        = "private-sg-${var.infra_env}"
  description = "Private internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "private_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_in" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [aws_vpc.vpc.cidr_block]

  security_group_id = aws_security_group.private.id
}

resource "aws_security_group" "logs_endpoint" {
  name        = "logs-public-sg-${var.infra_env}"
  description = "public internet access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "EC2 Security group redirection"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    description = "EC2 Security group redirection"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_api_gateway_sg" {
  name        = "api-gateway-public-sg-${var.infra_env}"
  description = "public internet access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP TCP to api gateway"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS TCP to api gateway"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "private_cloudflare_gate_sg" {
  name        = "cloudflare-gate-private-sg-${var.infra_env}"
  description = "public internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "private_cloudflare_ingress" {
  count = length(var.ipv4address_range_list)

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [var.ipv4address_range_list[count.index]]

  security_group_id = aws_security_group.private_cloudflare_gate_sg.id
}

resource "aws_security_group_rule" "private_cloudflare_ingress_with_sg" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [aws_vpc.vpc.cidr_block]

  security_group_id = aws_security_group.private_cloudflare_gate_sg.id
}

resource "aws_security_group_rule" "private_cloudflare_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private_cloudflare_gate_sg.id
}