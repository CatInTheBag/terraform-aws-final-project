variable "subnet_cidr_block" {
  type = list(string)
  description = "cidr block for vpc and subnets"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "vpc cidr block"
}

variable "env_prefix" {
  type = string
  description = "environment"
}

variable "availability_zone"{
  type = string
  description = "AZ"
}

variable "az_subnet_prefix"{
  type = string
  description = "AZ subnet"
}

variable "my_ip" {
  type = string
  description = "ip for ssh"
}

variable "instance_type" {
  type = string
  description = "ami instance type"
}

variable public_key {}