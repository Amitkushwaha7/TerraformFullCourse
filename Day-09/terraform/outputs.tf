# EC2 Instance Outputs

output "web_server_id" {
  description = "ID of the web server instance (create_before_destroy_example)"
  value       = aws_instance.web-server.id
}

output "web_server_public_ip" {
  description = "Public IP of the web server instance"
  value       = aws_instance.web-server.public_ip
}

output "app_instance_id" {
  description = "ID of app instance with security group"
  value       = aws_instance.app_with_sg.id
}

# S3 Bucket Outputs

# output "critical_bucket_name" {
#   description = "Name of the critical s3 bucket"
#   value       = aws_s3_bucket.critical_data.id
# }
#
# output "critical_bucket_arn" {
#   description = "ARN of the critical s3 bucket"
#   value       = aws_s3_bucket.critical_data.arn
# }

output "regional_validation_bucket" {
  description = "Name of the region-validated bucket"
  value       = aws_s3_bucket.regional_validation.id
}

# output "Compliance_bucket_name" {
#   description = "Name of the compliance bucket"
#   value       = aws_s3_bucket.Compliance_bucket.id
# }

output "app_bucket_names" {
  description = "Name of the application bucjets created wuth for each"
  value       = [for bucket in aws_s3_bucket.app_buckets : bucket.id]
}

output "app_bucket_arns" {
  description = "ARNs of application buckets"
  value       = { for key, bucket in aws_s3_bucket.app_buckets : key => bucket.arn }
}

# Auto Scaling Outputs

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_servers.min_size
}

output "asg_min_size" {
  description = "Minimum size of the ASG"
  value       = aws_autoscaling_group.app_servers.min_size
}

output "asg_max_size" {
  description = "Maximum size of the ASG"
  value       = aws_autoscaling_group.app_servers.max_size
}

output "asg_desired_capacity" {
  description = "Desired capacity of the ASG"
  value       = aws_autoscaling_group.app_servers.desired_capacity
}

# Security Group Outputs

output "security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "security_group_name" {
  description = "Name of the application security group"
  value       = aws_security_group.app_sg.name
}

# Region Information

output "current_region" {
  description = "Current AWS region being used"
  value       = data.aws_region.current.id
}

output "allowed_regions" {
  description = "List of allowed regions for deployment"
  value       = var.allowed_regions
}

# AMI Information

output "amazon_linux_ami_id" {
  description = "ID of the Amazon Linux 2 AMI being used"
  value       = data.aws_ami.amamzon_linux2.id
}

output "amazon_linux_ami_name" {
  description = "Name of the Amazon Linux 2 AMI"
  value       = data.aws_ami.amamzon_linux2.name
}