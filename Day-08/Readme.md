# Day-08: Terraform Meta-Arguments & Remote State

This module demonstrates key Terraform meta-arguments (`count`, `for_each`, `depends_on`, `lifecycle`) and use of an S3 remote backend for state management.

## Purpose
- Show how to create multiple similar resources with `count`.
- Show keyed resource creation with `for_each`.
- Enforce explicit ordering with `depends_on`.
- Control replacement and deletion behavior with `lifecycle`.
- Store state remotely in S3 for collaboration.

## Backend
Defined in `terraform/backend.tf`:
- Bucket: `my-terraform-state-bucket-aws-123456789`
- Key: `day-08/terraform.tfstate`
- Region: `us-east-1`
- Encryption: enabled (S3 default server-side)
Create the bucket before `terraform init`. Optionally add a DynamoDB table for locking.

## Provider
`provider.tf` pins:
- Terraform version: `>= 1.6.0`
- AWS provider: `~> 5.0`
- Default tags added automatically (Project, Day, Environment, ManagedBy).

## Variables (selected)
Defined in `terraform/variables.tf` with defaults; override in `terraform.tfvars` if needed.
- `environment` (string) – environment label (default `dev`).
- `region` (string) – AWS region (default `us-east-2`).
- `bucket_names` (list(string)) – names for the `count` example.
- `bucket_names_foreach` (list(string)) – names for the `for_each` example (kept separate to avoid name collisions).
- Additional examples: numbers (`storage_size`), bools (`enable_monitoring`), complex types (`network_config`, `server_config`).

## Locals
`local.tf` provides `common_tags` and `merged_tags = merge(common_tags, instance_tags)`. Current resources use inline tags; `merged_tags` is available for future reuse.

## Resources (`terraform/main.tf`)
1. `aws_s3_bucket.bucket1` (count)
	- Uses `count = length(var.bucket_names)` and `count.index` for indexing.
2. `aws_s3_bucket.example_foreach` (for_each)
	- Uses `for_each = toset(var.bucket_names_foreach)`; access with `each.value`.
3. `aws_s3_bucket.primary` & `aws_s3_bucket.dependent`
	- `dependent` uses `depends_on = [aws_s3_bucket.primary]` for explicit sequencing.
4. `aws_s3_bucket.lifecycle_example`
	- Demonstrates `lifecycle` meta-argument: `create_before_destroy`, `prevent_destroy` (false here), and `ignore_changes` on a specific tag.

### Meta-Argument Notes
- `count` creates anonymous indexed instances; index shifts if list order changes.
- `for_each` uses stable keys (map/set); avoids destructive recreation when ordering changes.
- Convert lists to sets (`toset(var.bucket_names_foreach)`) for `for_each` if uniqueness is desired.
- `depends_on` only needed when Terraform cannot infer dependency from references.
- `lifecycle` can safeguard critical resources (`prevent_destroy = true` in production) or ensure seamless replacements (`create_before_destroy = true`).

## Outputs (`terraform/outputs.tf`)
- `s3_bucket_names_count` / `s3_bucket_arns_count` – from `count` resources.
- `s3_bucket_names_foreach` / `s3_bucket_arns_foreach` – from `for_each` resources.
- `primary_bucket_name`, `dependent_bucket_name` – dependency example.
- `lifecycle_example_bucket` – lifecycle example name.

## Usage
```bash
cd Day-08/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

### Example `terraform.tfvars`
```hcl
region               = "us-east-1"
environment          = "dev"
bucket_names         = ["my-unique-bucket-name-123456-aws-terraform-a"]
bucket_names_foreach = ["my-unique-bucket-name-123456-aws-terraform-b"]
```

## Key Takeaways
- Use `count` for simple numeric replication; prefer `for_each` when identity matters.
- Remote state enables safe collaboration; protect state bucket from public access.
- Lifecycle rules help manage resource replacement and accidental deletions.

