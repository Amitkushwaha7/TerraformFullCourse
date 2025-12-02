# Output for COUNT-based resources
# Using splat expression to get all bucket name

output "s3_bucket_names_count" {
  description = "Name of S3 buckets created with count (using splat expression)"
  value = aws_s3_bucket.bucket1[*].bucket
}

# Using splat expression to get all bucket ARNs
output "s3_bucket_arns_count" {
  description = "ARNs of S3 buckets created with count"
  value       = aws_s3_bucket.bucket1[*].arn
}

# Outputs for FOR_EACH-based resources
output "s3_bucket_names_foreach" {
  description = "Names of S3 buckets created with for_each"
  value       = values(aws_s3_bucket.example_foreach)[*].bucket
}

output "s3_bucket_arns_foreach" {
  description = "ARNs of S3 buckets created with for_each"
  value       = values(aws_s3_bucket.example_foreach)[*].arn
}

output "primary_bucket_name" {
  description = "Name of the primary bucket"
  value       = aws_s3_bucket.primary.bucket
}

output "dependent_bucket_name" {
  description = "Name of the dependent bucket"
  value       = aws_s3_bucket.dependent.bucket
}

output "lifecycle_example_bucket" {
  description = "Name of lifecycle example bucket"
  value       = aws_s3_bucket.lifecycle_example.bucket
}
