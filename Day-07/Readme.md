# Day-07: Terraform Type Constraints

This day demonstrates all major **Terraform variable type constraints** through a practical AWS infrastructure example.

## What You'll Learn

Understanding type constraints is essential for writing reliable, self-documenting Terraform code. This example covers:

- **Primitive Types**: `string`, `number`, `bool`
- **Collection Types**: `list`, `map`, `set`
- **Structural Types**: `tuple`, `object`

## Resources Created

- **EC2 Instance** (`aws_instance.web_server`): Web server with configurable monitoring
- **Security Group** (`aws_security_group.web_sg`): Controls SSH (port 22) and HTTP (port 80) access

## Type Constraints Explained

### 1. String Type
Used for text values like region, environment, instance type.
```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

### 2. Number Type
Used for numeric values like instance count, storage size.
```hcl
variable "instance_count" {
  type    = number
  default = 1
}
```

### 3. Bool Type
Used for true/false flags like monitoring, public IP association.
```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}
```

### 4. List Type
**Ordered** collection that **allows duplicates**. Access by index: `var.name[0]`
```hcl
variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/8", "172.16.0.0/12"]
}
```

### 5. Map Type
**Key-value pairs** where keys are unique strings.
```hcl
variable "instance_tags" {
  type = map(string)
  default = {
    "Environment" = "dev"
    "Project"     = "terraform-course"
  }
}
```

### 6. Set Type
**Unordered** collection with **no duplicates**. Cannot access by index directly.
```hcl
variable "availability_zones" {
  type    = set(string)
  default = ["us-east-1a", "us-east-1b"]
}
# Access: tolist(var.availability_zones)[0]
```

### 7. Tuple Type
**Fixed-length** list where each position has a **specific type**.
```hcl
variable "network_config" {
  type    = tuple([string, string, number])
  default = ["10.0.0.0/16", "10.0.1.0/24", 80]
}
# Access: var.network_config[0], var.network_config[2]
```

### 8. Object Type
**Named attributes** with specific types for each field.
```hcl
variable "server_config" {
  type = object({
    name           = string
    instance_type  = string
    monitoring     = bool
    storage_gb     = number
    backup_enabled = bool
  })
  default = {
    name           = "web-server"
    instance_type  = "t2.micro"
    monitoring     = true
    storage_gb     = 20
    backup_enabled = false
  }
}
# Access: var.server_config.name, var.server_config.monitoring
```

## Key Differences

| Type | Ordered? | Duplicates? | Access Method | Use Case |
|------|----------|-------------|---------------|----------|
| `list` | ✅ Yes | ✅ Allowed | `var.name[0]` | Ordered collections |
| `set` | ❌ No | ❌ Not allowed | Convert to list first | Unique values |
| `map` | ❌ No | Keys unique | `var.name["key"]` | Key-value lookups |
| `tuple` | ✅ Yes | ✅ Allowed | `var.name[0]` | Fixed structure |
| `object` | N/A | N/A | `var.name.attribute` | Complex configs |

## Files Structure

```
Day-07/
├── main.tf         # EC2 instance and security group resources
├── variables.tf    # All type constraint examples with documentation
├── provider.tf     # AWS provider configuration
├── backend.tf      # S3 backend configuration for remote state
├── locals.tf       # Local values and computed data
├── outputs.tf      # Output values demonstrating type usage
├── .gitignore      # Git ignore patterns for Terraform files
└── Readme.md       # This file
```

## Prerequisites

Before running this configuration:
1. Ensure the S3 bucket `my-terraform-state-bucket-123456789` exists in `us-east-1`
2. Configure AWS credentials (`aws configure` or environment variables)
3. Optionally create a DynamoDB table for state locking

## Usage

```bash
# Initialize Terraform (connects to S3 backend)
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply

# View outputs
terraform output

# Cleanup
terraform destroy
```

## Outputs Provided

The configuration outputs demonstrate how each type works:
- `instance_ids`, `instance_public_ips`, `instance_private_ips` - EC2 instance details
- `security_group_id` - Security group ID
- `environment_info` - String type demonstration
- `storage_info` - Number type demonstration (disk size in GB/MB)
- `monitoring_policy` - Boolean type demonstration
- `allowed_regions` - List type demonstration
- `tags_info` - Map type demonstration
- `network_configuration` - Tuple type demonstration
- `instance_types_info` - List type with allowed instance types
- `server_configuration` - Object type demonstration
- `all_resource_tags` - Computed tags from locals

## Best Practices

1. **Use specific types** instead of `any` for better validation
2. **Document each variable** with clear descriptions
3. **Provide sensible defaults** where appropriate
4. **Use `object` type** for complex configurations (self-documenting)
5. **Use `list` when order matters**, `set` when uniqueness matters
6. **Use `tuple`** when you need mixed types in specific positions

## Backend Configuration

This project uses **S3 backend** for remote state storage:
- **Bucket**: `my-terraform-state-bucket-123456789`
- **Key**: `day-07/terraform.tfstate`
- **Region**: `us-east-1`
- **Encryption**: Enabled

Benefits of remote state:
- Team collaboration (shared state)
- State locking (prevents concurrent modifications)
- Backup and versioning
- Security (encrypted at rest)

## Notes

- Set types require conversion to list for index access: `tolist(var.availability_zones)[0]`
- Tuple enforces both length and type for each position
- Object types are self-documenting and catch typos at plan time
- All resources include default tags via provider configuration
- The S3 backend bucket must exist before running `terraform init`

---