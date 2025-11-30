terraform {
  backend "s3" {
    bucket         = "my-aws-terraform-demo-bucket-123456789"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile  = "true"
    encrypt        = true
  }
}