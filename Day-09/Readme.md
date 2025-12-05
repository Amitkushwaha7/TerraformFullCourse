# Day-09: Terraform Lifecycle Meta-arguments (AWS)

Focus: lifecycle meta-arguments that control create/update/destroy behavior with AWS examples.

## Topics Covered
- `create_before_destroy` — zero-downtime replacements
- `prevent_destroy` — protect critical resources
- `ignore_changes` — ignore external or autoscaling updates
- `replace_triggered_by` — replace on dependency change
- `precondition` — validate before create/update
- `postcondition` — validate after create/update

## Learning Objectives
- Know when and how to use each lifecycle rule
- Protect production resources and data
- Enable zero-downtime updates
- Handle resources modified by external systems
- Validate resources before and after creation

## Key Lifecycle Notes (mapped to this code)
- `create_before_destroy`: EC2 `web-server` creates a replacement before teardown (good for zero downtime; avoid if names must stay identical).
- `prevent_destroy`: S3 `secret_data` can block deletion; toggle to allow destroy when cleaning up.
- `ignore_changes`: ASG `app_servers` ignores `desired_capacity` drift from autoscaling policies.
- `replace_triggered_by`: EC2 `app_with_sg` is replaced when `app_sg` changes.
- `precondition`: S3 `regional_validation` blocks creation outside `allowed_regions`.
- `postcondition`: S3 `Compliance_bucket` enforces required tags after creation.
- Combined rules: DynamoDB `critical_app_data` layers multiple protections.

## Resources (by category)
- Compute: `aws_instance.web-server`, `aws_instance.app_with_sg`, `aws_launch_template.app_server`, `aws_autoscaling_group.app_servers`
- Storage: `aws_s3_bucket.secret_data`, `aws_s3_bucket_versioning.secret_bucket`, `aws_s3_bucket.regional_validation`, `aws_s3_bucket.Compliance_bucket`, `aws_s3_bucket.app_buckets` (for_each)
- Database: `aws_dynamodb_table.critical_app_data`
- Network: `aws_security_group.app_sg`

## Inputs
- `aws_region` (string, default `us-east-1`)
- `environment` (string, default `dev`)
- `bucket_names` (set(string)) for app buckets
- `allowed_regions` (list(string)) for region validation
- `instance_type` (string, default `t2.micro`)
- `instance_name` (string, default `lifecycle-demo-instance`)
- `resource_tags` (map(string)) common tags

## Outputs (high level)
- EC2 IDs and public IP
- ASG sizing (min/max/desired)
- S3 bucket names/ARNs (app buckets, regional validation)
- Security group ID/name
- Region and AMI details

## How to Run
```bash
cd Day-09/terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
# terraform destroy
```

## Notes
- S3 names include suffixes to avoid global name collisions.
- Set `prevent_destroy = true` for production-protected buckets; false for teardown.
- Default tags come from the provider plus resource-level merges.
- `bucket_names` default is a plain list (Terraform coerces to set) to satisfy variable default rules.
- AMI data source is `aws_ami.amazon_linux2`; outputs and instances reference this corrected name.
