resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

}

resource "aws_subnet" "public_az_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-AZ_1"
  }
}

resource "aws_subnet" "public_az_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-AZ_2"
  }
}

resource "aws_subnet" "private_web_az_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_subnet_az1
  availability_zone = var.az1
  tags = {
    Name = "private-web-subnet-AZ_1"
  }
}

resource "aws_subnet" "private_web_az_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_subnet_az2
  availability_zone = var.az2
  tags = {
    Name = "private-web-subnet-AZ_2"
  }
}

resource "aws_subnet" "private_db_az_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_az1
  availability_zone = var.az1
  tags = {
    Name = "private-db-subnet-AZ_1"
  }
}

resource "aws_subnet" "private_db_az_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_az2
  availability_zone = var.az2
  tags = {
    Name = "private-db-subnet-AZ_2"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_az_1.id

  depends_on = [
    aws_internet_gateway.igw,
    aws_subnet.public_az_1,
    aws_eip.nat_eip
  ]

  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.public_rt_name
  }
}

resource "aws_route_table_association" "public_az_1" {
  subnet_id      = aws_subnet.public_az_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_az_2" {
  subnet_id      = aws_subnet.public_az_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = var.private_rt_name
  }
}

resource "aws_route_table_association" "private_web_az_1" {
  subnet_id      = aws_subnet.private_web_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_web_az_2" {
  subnet_id      = aws_subnet.private_web_az_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_az_1" {
  subnet_id      = aws_subnet.private_db_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_az_2" {
  subnet_id      = aws_subnet.private_db_az_2.id
  route_table_id = aws_route_table.private_rt.id
}
