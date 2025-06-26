resource "aws_vpc" "test" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = var.name 
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name        = var.name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.test.id
  cidr_block              = cidrsubnet("192.168.0.0/20", 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.test.id
  cidr_block        = cidrsubnet("192.168.16.0/20", 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway in public subnet 0
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "my_rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}