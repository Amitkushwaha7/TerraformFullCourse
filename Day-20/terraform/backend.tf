# Terraform Backend Configuration (RECOMMENDED FOR PRODUCTION)
# This file enables remote state storage, which is essential for team collaboration
# and prevents state file corruption.

# Uncomment and configure the backend when you're ready for production deployment.
# For local development, comment this out.

terraform {
  # Option 1: AWS S3 + DynamoDB Backend (RECOMMENDED)
  # This stores your state file encrypted in S3 with DynamoDB locking
  # to prevent concurrent modifications.
  
  # backend "s3" {
  #   bucket         = "amit-eks-terraform-state"  # Change to your bucket name
  #   key            = "day-20/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"           # Change to your table name
  #   
  #   # These can also be set via environment variables or -backend-config flags
  # }
  
  # Option 2: Local Backend (CURRENT - For Development Only)
  # Stores state file locally. NOT SAFE for team environments.
  
  # To set up S3 backend:
  # 1. Create S3 bucket:
  #    aws s3api create-bucket --bucket amit-eks-terraform-state --region us-east-1
  # 
  # 2. Create DynamoDB table for locking:
  #    aws dynamodb create-table \
  #      --table-name terraform-locks \
  #      --attribute-definitions AttributeName=LockID,AttributeType=S \
  #      --key-schema AttributeName=LockID,KeyType=HASH \
  #      --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  #      --region us-east-1
  #
  # 3. Enable versioning on S3 bucket:
  #    aws s3api put-bucket-versioning \
  #      --bucket amit-eks-terraform-state \
  #      --versioning-configuration Status=Enabled
  #
  # 4. Uncomment the backend block above and run:
  #    terraform init
  #
  # This will migrate your state from local to remote storage automatically.
}
