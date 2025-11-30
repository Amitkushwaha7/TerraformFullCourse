output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_bucket.bucket
}

output "buket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_bucket.arn
}

output "environment" {
  description = "Environment from input variable"
  value       = var.environment
}


output "vpc_id" {
  description = "VPC CIDR Block"
  value       = aws_vpc.terraform_vpc.cidr_block
}

output "instance_type" {
  description = "EC2 Instance Type"
  value       = aws_instance.my_instance.instance_type
}