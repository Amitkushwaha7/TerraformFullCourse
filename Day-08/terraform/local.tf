locals {
  common_tags = {
    Environment = var.environment
    LOB         = "banking"
    Stage       = "alpha"
    ManagedBy   = "Terraform"
  }

  # Merge common tags with instance-specific tags variable (instance_tags)
  merged_tags = merge(local.common_tags, var.instance_tags)
}