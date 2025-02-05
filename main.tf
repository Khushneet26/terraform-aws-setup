terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  project_name = "lab_week_4"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_vpc" "web" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.project_name
  }
}

resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.web.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = local.project_name
  }
}

resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = local.project_name
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = local.project_name
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web-gw.id
}

resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.web.id
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.web.id
  name   = "web-sg"

  tags = {
    Name = local.project_name
  }
}

# Allow SSH (port 22)
resource "aws_security_group_rule" "web-ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id
  from_port         = 22
  to_port           = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]  # Allow SSH from anywhere (modify for security)
}

# Allow HTTP (port 80)
resource "aws_security_group_rule" "web-http" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id
  from_port         = 80
  to_port           = 80
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]  # Allow HTTP from anywhere
}

resource "aws_vpc_security_group_egress_rule" "web-egress" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_terraform_key"
  public_key = file("~/.ssh/my_terraform_key.pub")
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  subnet_id              = aws_subnet.web.id
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("cloud-config.yml")

  tags = {
    Name = local.project_name
  }
}

output "instance_ip_addr" {
  description = "The public IP and DNS of the web EC2 instance."
  value = {
    "public_ip" = aws_instance.web.public_ip
    "dns_name"  = aws_instance.web.public_dns
  }
}

