output "bucket_name" {
    description = "Name of the S3 bucket"
    value = aws_s3_bucket.terraform_bucket.bucket
}

output "bucket_arn" {
    description = "ARN of the S3 bucket"
    value = aws_s3_bucket.terraform_bucket.arn
}
output "environment" {
  description = "Environment from input variable"
  value = var.environment
}

output "tags" {
  description = "Tags of the EC2 instance"
  value = local.common_tags
}

output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.terraform_vpc.id
}
output "instance_type" {
  description = "EC2 Instance Type"
  value = aws_instance.my_instance.instance_type
}