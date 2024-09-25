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

module "website_s3_bucket" {
  source = "./modules/s3-bucket"

  bucket_name = "gibson-website-bucket" # overrides default value
}