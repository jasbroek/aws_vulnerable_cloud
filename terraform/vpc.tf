# VPC setup
resource "aws_vpc" "fc-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "False Compliance VPS"
    }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "fc-ig" {
  vpc_id = aws_vpc.fc-vpc.id
  tags = {
      Name = "False Compliance Internet Gateway"
  }
}

# Setup the public subnets
resource "aws_subnet" "fc-public-subnet-1" {
  availability_zone = "${var.region}a"
  vpc_id     = aws_vpc.fc-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "False Compliance public subnet 1"
  }
}
resource "aws_subnet" "fc-public-subnet-2" {
  availability_zone = "${var.region}b" 
  vpc_id     = aws_vpc.fc-vpc.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "False Compliance public subnet 2"
  }
}

# Setup private subnets
resource "aws_subnet" "fc-private-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.0.20.0/24"
  vpc_id = aws_vpc.fc-vpc.id
  tags = {
      Name = "False Compliance private subnet 1"
  }
}
resource "aws_subnet" "fc-private-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block = "10.0.30.0/24"
  vpc_id = aws_vpc.fc-vpc.id
  tags = {
      Name = "False Compliance private subnet 2"
  }
}

#
# Routing the subnets (create route table + associate)
#
resource "aws_route_table" "fc-public-subnet-route" {
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.fc-ig.id
  }
  vpc_id = aws_vpc.fc-vpc.id
  tags = {
      Name = "Route table for False Compliance public subnet"
  }
}
resource "aws_route_table_association" "fc-public-subnet-1-route-association" {
  subnet_id = aws_subnet.fc-public-subnet-1.id
  route_table_id = aws_route_table.fc-public-subnet-route.id
}
resource "aws_route_table_association" "fc-public-subnet-2-route-association" {
  subnet_id = aws_subnet.fc-public-subnet-2.id
  route_table_id = aws_route_table.fc-public-subnet-route.id
}

#Private routes
resource "aws_route_table" "fc-private-subnet-route" {
  vpc_id = aws_vpc.fc-vpc.id
  tags = {
      Name = "Route table for False Compliance private subnet"
  }
}
resource "aws_route_table_association" "cg-private-subnet-1-route-association" {
  subnet_id = aws_subnet.fc-private-subnet-1.id
  route_table_id = aws_route_table.fc-private-subnet-route.id
}
resource "aws_route_table_association" "cg-private-subnet-2-route-association" {
  subnet_id = aws_subnet.fc-private-subnet-2.id
  route_table_id = aws_route_table.fc-private-subnet-route.id
}
