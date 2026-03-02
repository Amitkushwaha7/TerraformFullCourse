# create bucket for terraform state
aws s3 mb s3://staging-my-terraform-bucket-amit-1001 --region us-east-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
    --bucket staging-my-terraform-bucket-amit-1001 \
    --versioning-configuration Status=Enabled

# Enable encryption on the bucket
aws s3api put-bucket-encryption \
    --bucket staging-my-terraform-bucket-amit-1001 \
    --server-side-encryption-configuration '{
        "Rules":[{
        "ApplyServerSideEncryptionByDefault":{
        "SSEAlgorithm":"AES256"
        }
        }]
        }'    