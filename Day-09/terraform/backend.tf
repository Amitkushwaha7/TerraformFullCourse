# Terraform Backend Configuration


terraform {
  backend "s3" {
    # S3 bucket name for storing state
    bucket = "my-terraform-state-bucket-aws-123456789"
    
    # Path to state file within the bucket
    key = "Day-09/terraform/terraform.tfstate"
    
    # AWS region where the bucket exists
    region = "us-east-2"
    
    # DynamoDB table for state locking
    # dynamodb_table = "terraform-state-lock"
    
    # Enable encryption at rest
    encrypt = true
    
    # Optional: Workspace-based state management
    # workspace_key_prefix = "workspaces"
  }
}


# To use the backend:
# 1. Create an S3 bucket for state storage
# 2. Create a DynamoDB table with primary key "LockID" (String)
# 3. Update bucket, key, region, and table name
# 4. Run: terraform init -reconfigure