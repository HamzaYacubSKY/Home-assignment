variable "access_key" {
  description = "access key for aws credentials"
}

variable "secret_key" {
  description = "secret key for aws credentials"
}

variable "cidr" {
  description = "CIDR block for vpc"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
}

variable "key_pair" {
  description = "key_pair for ec2 instance"
}
