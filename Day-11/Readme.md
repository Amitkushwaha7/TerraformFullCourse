# Day-11: Terraform Local Values & Built-in Functions (AWS)

Focus: using local values and built-in functions for string manipulation, data transformation, and configuration logic.

## Topics Covered
- **Local Values** — define reusable computed values within the configuration
- **String Functions** — `lower()`, `replace()`, `substr()`, `split()`
- **Collection Functions** — `merge()`, `lookup()`, `for` expressions
- **Data Transformation** — combining functions to clean and format inputs

## Learning Objectives
- Declare and use `locals` blocks for intermediate calculations
- Apply built-in functions to format, clean, and manipulate strings
- Use `lookup()` to select values from maps based on keys
- Transform data with `for` expressions and merge operations

## Key Concepts (mapped to this code)

### 1. String Manipulation with Functions
- **`lower()`** — converts strings to lowercase
- **`replace()`** — replaces substrings (spaces, special chars)
- **`substr()`** — extracts substring by start index and length

**Example:**
```hcl
formatted_project_name = lower(replace(var.project_name, " ", "_"))
```
Converts `"Project ALPHA Resource"` → `"project_alpha_resource"`

**Bucket Name Formatting:**
```hcl
formatted_bucket_name = replace(replace(
  substr(lower(var.bucket_name), 0, 63),
  " ", ""
), "!", "")
```
Cleans bucket name: lowercase, removes spaces/special chars, limits to 63 chars (S3 naming rules).

---

### 2. Collection Operations

**Merge Tags:**
```hcl
new_tags = merge(var.default_tags, var.environment_tags)
```
Combines `default_tags` and `environment_tags` into a single map.

**Split String into List:**
```hcl
port_list = split(",", var.allowed_ports)
```
Converts `"80,443,8080"` → `["80", "443", "8080"]`

---

### 3. For Expressions
Generates a list of security group rule objects from port list:

```hcl
sg_rules = [for port in local.port_list : {
  name        = "port-${port}"
  port        = port
  description = "Allow traffic on port ${port}"
}]
```

**Result:** list of objects, one per port, ready for dynamic block usage.

---

### 4. Lookup Function
Selects instance size based on environment key:

```hcl
instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")
```

- `dev` → `t2.micro`
- `staging` → `t3.small`
- `prod` → `t3.large`
- default fallback: `t2.micro`

---

## Resources Created
- **Storage:** `aws_s3_bucket.firsts3` — bucket with formatted name and merged tags

## Inputs
- `project_name` (string, default `"Project ALPHA Resource"`) — project identifier
- `default_tags` (map, default `{company, managed_by}`) — base tags
- `environment_tags` (map, default `{environment, cost_center}`) — environment-specific tags
- `bucket_name` (string, default with caps/spaces/special chars) — raw bucket name
- `allowed_ports` (string, default `"80,443,8080"`) — comma-separated ports
- `instance_sizes` (map, default `{dev, staging, prod}`) — environment-to-size mapping
- `environment` (string, default `"dev"`) — current environment key

## Outputs
- `formatted_project_name` — cleaned project name (lowercase, underscores)
- `port_list` — list of port strings parsed from `allowed_ports`
- `sg_rules` — list of security group rule objects
- `instance_size` — selected instance type based on environment

## How to Run
```bash
cd Day-11/terraform
terraform init
terraform validate
terraform plan
terraform apply
# terraform destroy
```

## Notes
- Locals are evaluated once and cached; good for computed values used multiple times.
- String functions ensure resource names meet AWS naming constraints (S3 bucket rules).
- `lookup()` provides safe map access with a default fallback.
- `for` expressions transform collections into structured data for resources.
- No provider configuration file present; ensure AWS credentials are configured externally.
