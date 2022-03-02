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
  region = var.region
  # credentials passed as env vars before terraform init had occurred
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
  availability_zone = var.az_01
  cidr_block = var.subnet01_cidr
  vpc_id     = aws_vpc.vpc01.id

  tags = {
    Name = "subnet01"
  }
}

resource "aws_subnet" "subnet02" {
  availability_zone = var.az_02
  cidr_block = var.subnet02_cidr
  vpc_id     = aws_vpc.vpc01.id

  tags = {
    Name = "subnet02"
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

  ingress {
    description = "custom port from VPC"
    from_port   = "8080"
    to_port     = "8080"
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

# ##################### EC2 ######################
resource "aws_instance" "node01" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet01.id
  vpc_security_group_ids      = [aws_security_group.sg01.id]
  associate_public_ip_address = true
  monitoring                  = true

  tags = {
    Name = "Worker node - 1"
  }
}

resource "aws_instance" "node02" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet02.id
  vpc_security_group_ids      = [aws_security_group.sg01.id]
  associate_public_ip_address = true
  monitoring                  = true

  tags = {
    Name = "Worker node - 2"
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

resource "aws_route_table_association" "rta1" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet01.id
}

resource "aws_route_table_association" "rta2" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet02.id
}
###############################################

############### LOAD BALANCER #################

resource "aws_lb_target_group" "tg01" {
  name     = "tg01"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc01.id
}

resource "aws_lb_target_group_attachment" "tga01" {
  target_group_arn = aws_lb_target_group.tg01.arn
  target_id        = aws_instance.node01.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "tga02" {
  target_group_arn = aws_lb_target_group.tg01.arn
  target_id        = aws_instance.node02.id
  port             = 8080
}

resource "aws_lb" "lb01" {
  name               = "alb01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg01.id]
  subnets            = [aws_subnet.subnet01.id, aws_subnet.subnet02.id]

  enable_deletion_protection = false
}

resource "aws_acm_certificate" "cert" {
  private_key      = file("key.pem")
  certificate_body = file("cert.pem")
}

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.lb01.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg01.arn
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.lb01.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
###############################################
