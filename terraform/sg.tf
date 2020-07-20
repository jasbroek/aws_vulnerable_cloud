# Security Groups

# Edit default security group to comply with CIS rules (remove default 0.0.0.0 egress)
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.fc-vpc.id
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  tags = {
    Name = "fc-ubuntu-18-sg-${var.unique_id}"
  }
}


resource "aws_security_group" "fc-ubuntu-18-sg" {
  name = "fc-ubuntu-18-sg-${var.unique_id}"
  description = "FC security group for access to EC2 instances over HTTP and SSH"
  vpc_id = aws_vpc.fc-vpc.id
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = var.connection_ips
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = var.connection_ips
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  }
  tags = {
    Name = "fc-ubuntu-18-sg-${var.unique_id}"
  }
}