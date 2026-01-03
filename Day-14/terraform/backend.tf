terraform {
  backend "s3" {
    bucket = "my-aws-terraform-state-bucket-amit-123"
    key    = "Day-14/terraform/terraform.tfstate"
    region = "us-east-1"
  }
}