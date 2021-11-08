terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARBEGBEKMAYSGGQ55"
  secret_key = "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"
}

resource "aws_instance" "web" {
  ami           = "ami-0057d8e6fb0692b80"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-amandine"
  }

  root_block_device {
    delete_on_termination = true
  }
}

