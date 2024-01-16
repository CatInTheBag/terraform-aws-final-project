variable "subnet_cidr_block" {
  type = list(string)
  description = "cidr block for vpc and subnets"
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

variable "vpc_id" {}