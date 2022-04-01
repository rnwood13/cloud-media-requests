terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75, < 4.0.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.vpc_region

  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "Woody"
      Terraform   = "True"
      Project     = var.project_name
    }
  }
}
