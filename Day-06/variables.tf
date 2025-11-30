variable "region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment name like dev, stage, prod"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bucket_name" {
  description = "S3 Bucket name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}