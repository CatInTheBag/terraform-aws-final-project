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

variable public_key_path {}

# Create a VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
    vpc_env = var.env_prefix
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block[0]
  availability_zone = "${var.az_subnet_prefix}a"
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_subnet" "myapp-subnet-2" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block[1]
  availability_zone = "${var.az_subnet_prefix}b"
  tags = {
    Name = "${var.env_prefix}-subnet-2"
  }
}

resource "aws_internet_gateway" "myapp-internet-gateway" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-gateway"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-internet-gateway.id
  }

  tags = {
    Name = "${var.env_prefix}-route-table"
  }
}

resource "aws_route_table_association" "myapp-route-table-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-security-group" {
  name = "myapp security group"
  vpc_id = aws_vpc.myapp-vpc.id

  #incomming traffic rules
  ingress {
    #to configure range, from 22 to 22, only means one port 22
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outgoing traffic rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-security-group"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myapp-ec2" {
  #hardcoded cuz filter not working correctly 
  ami = "ami-024f768332f080c5e"
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  availability_zone = "${var.az_subnet_prefix}a"

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-myapp-ec2-instance-ssh"
  }
}

output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}

output "subnet_id" {
  value = aws_subnet.myapp-subnet-1.id
}

output "ec2_id" {
  value = aws_instance.myapp-ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.myapp-ec2.public_ip
}