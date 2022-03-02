variable "cidr" {
  description = "CIDR block for vpc"
}

variable "subnet01_cidr" {
  description = "CIDR block for subnet01"
}

variable "subnet02_cidr" {
  description = "CIDR block for subnet02"
}

variable "key_pair" {
  description = "key_pair for ec2 instance"
}

variable "region" {
  description = "default region that resources will be built in"
}

variable "az_01" {
  description = "availability zone for subnet01"
}

variable "az_02" {
  description = "availability zone for subnet02"
}

variable "ami" {
  description = "ubuntu ami for ec2 instance"
}

variable "instance_type" {
  description = "instance type for ec2 instance"
}

variable "ssl_policy" {
  description = "ssl policy for acm cert"
}