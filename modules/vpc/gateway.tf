# Create the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.infra_env}-vpc"
    Project     = "dynamic-tf"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}

# Create the nat gateway
# resource "aws_eip" "nat" {
#   domain                    = "vpc"
#   associate_with_private_ip = "10.0.0.5"

#   depends_on = [aws_internet_gateway.igw]
#   lifecycle {
#     # prevent_destroy = true
#   }

#   tags = {
#   }
# }

# Note: We're only creating one NAT Gateway, potential single point of failure
resource "aws_nat_gateway" "ngw" {
  # allocation_id = aws_eip.nat.id
  connectivity_type = "private"

  # Whichever the first public subnet happens to be
  # (because NGW needs to be on a public subnet with an IGW)
  # keys(): https://www.terraform.io/docs/configuration/functions/keys.html
  # element(): https://www.terraform.io/docs/configuration/functions/element.html
  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id

  tags = {
  }
  # depends_on = [aws_eip.nat]
}

###
# Route Tables, Routes and Associtoans
##

# Public Route Table (Subnets with IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
  }
}

# Private Route Tables (Subnets with NGW)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
  }
}

# Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Private Route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Public Route to Public Route Table for Public Subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# Private Route to Private Route Table for Private Subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}