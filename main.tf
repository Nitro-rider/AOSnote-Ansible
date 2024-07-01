terraform {
  required_providers {
    aws         = {
      source    = "hashicorp/aws"
      version   = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "ansible_vpc" {
  cidr_block        = "10.0.0.0/16"
  instance_tenancy  = "default"

  tags              = {
    Name            = "ansible vpc"
  }
}

resource "aws_security_group" "ansible-machine-sg" {
  name          = "ansible sg"
  description   = "Allow SSH traffic"
  vpc_id        = aws_vpc.ansible_vpc.id
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags          = {
    Name        = "ansible sg"
  }
}

resource "aws_security_group" "server_sg" {
  name          = "server sg"
  description   = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id        = aws_vpc.ansible-vpc.id
  ingress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80

  }
  tags          = {
    Name        = "server sg"
  }
}

