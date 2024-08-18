# Create a VPC for the region associated with the AZ
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
  }
}

# Create 1 public subnets for each AZ within the regional VPC
resource "aws_subnet" "public" {
  for_each = var.public_subnet_numbers

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
  }
}

# Create 1 private subnets for each AZ within the regional VPC
resource "aws_subnet" "private" {
  for_each = var.private_subnet_numbers

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
  }
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.logs_endpoint.id,
  ]

  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]
  private_dns_enabled = true

  dns_options {
    dns_record_ip_type = "ipv4"
  }

  tags = {
    Name = "logs-vpc-access"
  }
}