# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  # Configuration options
    region = "us-east-1"
}

# backend configuration
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-amit-123456789"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = "true"
    encrypt        = true
  }
}

