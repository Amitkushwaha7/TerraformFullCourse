terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-aws-123456789"
    key            = "day-08/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    # Optionally add dynamodb_table = "terraform-locks" for state locking
  }
}