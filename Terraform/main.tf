terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1.0"
    }
  }
}
################## PROVIDERS ##################
provider "aws" {
  region = "eu-west-2"
  # credentials were passed as env vars before terraform init had occurred
}
###############################################

################## NETWORK ####################
resource "aws_vpc" "vpc01" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = "vpc01"
  }
}

resource "aws_subnet" "subnet01" {
  cidr_block = var.subnet_cidr
  vpc_id     = aws_vpc.vpc01.id

  tags = {
    Name = "subnet01"
  }
}
#################################################

################ SECURITY GROUPS ################
resource "aws_security_group" "sg01" {
  name   = "sg01"
  vpc_id = aws_vpc.vpc01.id

  ingress {
    description = "SSH from VPC"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
################################################

##################### EC2 ######################
resource "aws_instance" "ansible-master" {
  ami                         = "ami-0015a39e4b7c0966f"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet01.id
  vpc_security_group_ids      = [aws_security_group.sg01.id]
  associate_public_ip_address = true
  monitoring                  = true
  user_data                   = file("scripts/install_ansible.sh")
  count                       = 1

  tags = {
    Name = "Ansible - Master"
  }
}

resource "aws_instance" "ansible-worker" {
  ami                         = "ami-0015a39e4b7c0966f"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet01.id
  vpc_security_group_ids      = [aws_security_group.sg01.id]
  associate_public_ip_address = true
  monitoring                  = true
  count                       = 0

  tags = {
    Name = "Ansible - Worker ${count.index + 1}"
  }
}
#################################################

################## IGW #########################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc01.id

  tags = {
    Name = "igw01"
  }
}
#################################################

################# ROUTE TABLE ###################
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet01.id
}
###############################################
