terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "Terraform-Full-Course-AWS"
      Day         = "08"
      Environment = var.environment
    }
  }
}