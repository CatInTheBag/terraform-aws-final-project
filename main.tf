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
  region = var.availability_zone
}

# Create a VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
    vpc_env = var.env_prefix
  }
}

module "myapp-subnet" {
  source = ".\\modules\\subnet"
  subnet_cidr_block = var.subnet_cidr_block
  env_prefix = var.env_prefix
  availability_zone = var.availability_zone
  az_subnet_prefix = var.az_subnet_prefix
  vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-server" {
  source = ".\\modules\\webserver"
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  public_key = var.public_key
  instance_type = var.instance_type
  az_subnet_prefix = var.az_subnet_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  availability_zone = var.availability_zone
  webserver_subnet_id = module.myapp-subnet.myapp-subnet-1.id
}