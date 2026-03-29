#!/bin/bash
# Script to create S3 bucket for Terraform state management

set -e

# 1. Dynamically fetch your AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="${2:-us-east-1}"

# 2. Use Account ID to guarantee a globally unique, predictable name
BUCKET_NAME="${1:-terraform-state-${ACCOUNT_ID}-${AWS_REGION}}"

echo "=========================================="
echo "Terraform Backend Setup (S3 Native Locking)"
echo "=========================================="
echo "Bucket Name: $BUCKET_NAME"
echo "Region: $AWS_REGION"
echo "========================================="

# 3. Check if bucket exists to make the script idempotent (safe to re-run)
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket $BUCKET_NAME already exists and is owned by you. Skipping creation."
else
  echo "Creating S3 bucket..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    $(if [ "$AWS_REGION" != "us-east-1" ]; then echo "--create-bucket-configuration LocationConstraint=$AWS_REGION"; fi)
  
  echo "Waiting 5 seconds for bucket to propagate globally..."
  sleep 5
fi

# Enable versioning
echo "Enabling versioning..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Enable encryption
echo "Enabling encryption..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
echo "Blocking public access..."
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo ""
echo "=========================================="
echo "✅ Backend setup complete!"
echo "=========================================="
echo "Update your backend config files (backend-dev.hcl & backend-prod.hcl)"
echo "Replace 'TERRAFORM_STATE_BUCKET' with: $BUCKET_NAME"
echo "=========================================="