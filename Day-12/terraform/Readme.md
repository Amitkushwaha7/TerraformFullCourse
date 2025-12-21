# Day 12 — Terraform Functions

Demonstrates 12 Terraform function patterns using AWS resources.

## Setup
- AWS credentials configured
- Region: `us-east-1`
- Provider: `hashicorp/aws` v6.27.0

## Usage
```bash
terraform init
terraform plan
terraform apply
terraform output
```

## Resources Created
- Resource Group, 2 VPCs, Security Group
- 2 S3 buckets, 2 EC2 instances
- Secrets Manager secret

## Key Variables
- `environment`: dev/staging/prod
- `instance_type`: t2.* or t3.*
- `bucket_name`: sanitized for S3
- `allowed_ports`: "80,443,8080,3306"
- `backup_name`: must end with _backup

## Functions Covered
**String:** lower, upper, replace, substr, trim, split, join, chomp  
**Numeric:** abs, max, min, ceil, floor, sum  
**Collection:** length, concat, merge, reverse, toset, tolist  
**Conversion:** tonumber, tostring, tobool  
**File:** file, fileexists, dirname, basename  
**Time:** timestamp, formatdate, timeadd  
**Validation:** can, regex, contains, startswith, endswith  
**Lookup:** lookup, element, index

## Cleanup
```bash
terraform destroy
```

