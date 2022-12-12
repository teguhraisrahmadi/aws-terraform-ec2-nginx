# Variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "private_key_path" {}
variable "region" {
  default = "us-east-1"
}


# Provider
provider "aws" {
  region  = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# DATA
data "aws_ami" "centos-7" {
  most_recent = true
  owners      = ["679593333241"]

 filter {
    name   = "name"
    values = ["CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
      name   = "architecture"
      values = ["x86_64"]
  }
  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}


# RESOURCES
resource "aws_instance" "centos-7" {
  instance_type          	= "t2.micro"
  ami                    	= data.aws_ami.centos-7.id
  key_name               	= var.key_name
  vpc_security_group_ids      	= [aws_security_group.demo_sg.id]
  associate_public_ip_address 	= true
}  

# Security group
resource "aws_security_group" "demo_sg" {
  name        			= "demo_sg"
  description 			= "allow ssh, http & https"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.centos-7.public_dns
}

