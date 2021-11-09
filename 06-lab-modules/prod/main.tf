terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  #define the remote backend
  backend "s3" {
    bucket = "terraform-backend-amandine"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}

#configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#include ec2 module
module "ec2module" {
  source = "../Module/ec2module"

  #define the variables
  taille_ec2 = "t2.micro"
  ec2_tag = {
    Name = "ec2_prod_amandine"
  }
  sg_name = "sg_prod_amandine"
  sg_tag = {
    Name = "sg_prod_amandine"
  }
  key_name = "devops-amandine"
  key_path = "./devops-amandine.pem"
}