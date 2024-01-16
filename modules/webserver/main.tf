resource "aws_security_group" "myapp-security-group" {
  name = "myapp security group"
  vpc_id = var.vpc_id

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
  public_key = var.public_key
}

resource "aws_instance" "myapp-ec2" {
  #hardcoded cuz filtering with data not working correctly 
  ami = "ami-0faab6bdbac9486fb"
  instance_type = var.instance_type

  subnet_id = var.webserver_subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-security-group.id]
  availability_zone = "${var.availability_zone}a"

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-myapp-ec2-instance-ssh"
  }
}