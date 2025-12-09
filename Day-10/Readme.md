# Day-10: Terraform Expressions (AWS)

Focus: conditional expressions, dynamic blocks, and splat expressions for flexible infrastructure code.

## Topics Covered
- **Conditional Expressions** — select values based on conditions (`condition ? true_val : false_val`)
- **Dynamic Blocks** — generate repeated nested blocks from collections
- **Splat Expressions** — extract attributes from multiple resources (`[*]`)

## Learning Objectives
- Use ternary operators to conditionally set resource attributes
- Generate multiple configuration blocks dynamically from variables
- Extract values from lists of resources efficiently with splat syntax

## Key Concepts (mapped to this code)

### 1. Conditional Expression
**Resource:** `aws_instance.conditional_example`

Chooses instance type based on environment:
- `prod` → `t3.large`
- anything else → `t2.micro`

```hcl
instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
```

**Use Case:** Environment-specific sizing without duplicating resource blocks.

---

### 2. Dynamic Block
**Resource:** `aws_security_group.dynamic_sg`

Generates multiple `ingress` rules from `var.ingress_rules` list using a `dynamic` block:

```hcl
dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    = ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
    description = ingress.value.description
  }
}
```

Default creates HTTP (80) and HTTPS (443) rules. Add more rules in `variables.tf` `ingress_rules` list.

**Use Case:** Avoid repeating `ingress` blocks; manage rules as data.

---

### 3. Splat Expression
**Resource:** `aws_instance.splat_example` (count-based)

Creates `var.instance_count` instances (default 2). Locals use splat `[*]` to extract all IDs and IPs:

```hcl
locals {
  all_instance_ids = aws_instance.splat_example[*].id
  all_private_ips  = aws_instance.splat_example[*].private_ip
}
```

Outputs show full lists of IDs and private IPs.

**Use Case:** Quickly aggregate attributes from multiple resources without manual indexing.

---

## Resources Created
- **Compute:** `aws_instance.conditional_example` (1), `aws_instance.splat_example` (count = 2)
- **Network:** `aws_security_group.dynamic_sg` (with dynamic ingress rules)

## Inputs
- `aws_region` (string, default `us-east-1`)
- `environment` (string, default `dev`) — drives conditional instance type
- `instance_count` (number, default `2`) — number of splat example instances
- `ingress_rules` (list of objects) — each has `from_port`, `to_port`, `protocol`, `cidr_blocks`, `description`

## Outputs
- `conditional_instance_type` — instance type chosen by condition
- `conditional_instance_id` — ID of conditional example instance
- `dynamic_sg_id` — security group ID
- `security_group_rules_count` — number of ingress rules generated
- `all_instance_ids` — list of all splat example instance IDs
- `all_private_ips` — list of all splat example private IPs

## How to Run
```bash
cd Day-10/terraform
terraform init
terraform validate
terraform plan
terraform apply
# terraform destroy
```

## Notes
- Conditional expression simplifies environment-based configuration.
- Dynamic blocks keep security group rules maintainable as a list variable.
- Splat `[*]` syntax is shorthand for extracting attributes from all elements in a list/set.
- Data source `aws_ami.amazon_linux` fetches the latest Amazon Linux 2 AMI.
