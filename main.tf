terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-dev",
    vpc_env = "dev"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block[0]
  availability_zone = "eu-central-1a"
  tags = {
    Name = "subnet-1-dev"
  }
}

resource "aws_subnet" "myapp-subnet-2" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block[1]
  availability_zone = "eu-central-1a"
  tags = {
    Name = "subnet-2-dev"
  }
}

variable "subnet_cidr_block" {
  type = list(string)
  description = "cidr block for vpc and subnets"
}

variable "subnet_cidr_block_1" {
  type = string
  default = "10.0.10.0/24"
  description = "subnet cidr block"
}

variable "subnet_cidr_block_2"{
  type = string
  default = "10.0.20.0/24"
  description = "subnet 2 cidr block"
}

output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.myapp-subnet-1.id
}