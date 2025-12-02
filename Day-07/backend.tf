terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-aws-123456789"
    key            = "day-07/terraform.tfstate"
    region         = "us-east-2"
    use_lockfile  = "true"
    encrypt        = true
  }
}