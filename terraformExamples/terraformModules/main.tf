terraform {
  backend "s3" {
    bucket = "gibsonterraformbucket"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.48.0"
    }
  }

  required_version = ">= 1.8.2"
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "gibsonterraformbucket"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  count = 1
  name  = "my-ec2-cluster-${count.index}"

  ami                    = "ami-0a1179631ec8933d7" # Amazon Linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "sandbox"
  }
}
