resource "aws_instance" "my_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = local.common_tags
}

resource "aws_s3_bucket" "terraform_bucket" {
    bucket = local.full_bucket_name
    tags   = local.common_tags
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = local.common_tags
}