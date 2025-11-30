resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = var.bucket_name
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
}