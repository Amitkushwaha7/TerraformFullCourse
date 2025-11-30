# Day-05: AWS Basics with Variables, Locals & Outputs

This Terraform configuration provisions a minimal AWS setup demonstrating use of input variables, locals, and outputs.

## What It Creates
- EC2 instance (`aws_instance.my_instance`)
- S3 bucket with unique random suffix (`aws_s3_bucket.terraform_bucket`)
- VPC (`aws_vpc.terraform_vpc`)
- Random string resource for bucket name uniqueness (`random_string.suffix`)

## Variables (see `variables.tf` / `terraform.tfvars`)
- `region`: AWS region (e.g. `us-east-1`)
- `environment`: Environment label (e.g. `dev`)
- `ami_id`: AMI ID for the EC2 instance
- `instance_type`: EC2 instance type (e.g. `t2.micro`)
- `bucket_name`: Base bucket name (random suffix added)
- `vpc_cidr_block`: CIDR block for VPC (e.g. `10.0.0.0/16`)

## Locals (see `locals.tf`)
- `common_tags`: Shared tags applied to resources
- `full_bucket_name`: Composed bucket name: `<environment>-<bucket_name>-<random_suffix>`

## Outputs (see `outputs.tf`)
- `bucket_name`: Final S3 bucket name
- `buket_arn`: ARN of the S3 bucket (note: output name has a typo kept for accuracy)
- `environment`: Environment string passed in
- `tags`: Common tags map
- `vpc_id`: Actually returns the VPC CIDR block (name mismatch)
- `instance_type`: Instance type used

## Provider
AWS provider pinned (exact version) in `providers.tf`. Adjust if version constraints change.

## Usage
```bash
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply
# When finished
terraform destroy
```

---
This README reflects the current Day-05 state for clarity and quick onboarding.
