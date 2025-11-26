# Day-03: AWS S3 Bucket Creation

## Overview
This project creates an AWS S3 bucket with tags using Terraform.

## Files
- **provider.tf** - AWS provider configuration (version 6.22.1, region: us-east-1)
- **main.tf** - S3 bucket resource definition

## Resources Created
- **S3 Bucket**: `amit-terraform-course-bucket-03`
  - Tags:
    - Name: "My bucket"
    - Environment: "Dev"

## Commands
```bash
terraform init       # Initialize Terraform
terraform plan       # Preview changes
terraform apply      # Create the S3 bucket
terraform destroy    # Delete the S3 bucket
```

## Key Points
- Bucket names must be globally unique
- Use hyphens instead of underscores in bucket names
- Resources are tagged for better organization and management