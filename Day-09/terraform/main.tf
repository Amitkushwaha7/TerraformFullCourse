# Data Sources

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amamzon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get availabiluty zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
}


# Task:1 create_before_destroy example
resource "aws_instance" "web-server" {
  ami           = data.aws_ami.amamzon_linux2.id
  instance_type = var.instance_type

  tags = merge(
    var.resource_tags,
    {
      Name = var.instance_name
      Demo = "create_before_destroy"
    }
  )

  # Lifecycle Rule: Create new instance before destroying the old one
  # This ensures zero downtime during instance updates (e.g., changing AMI or instance type)

  lifecycle {
    create_before_destroy = true
  }
}

# Prevent Destroy

resource "aws_s3_bucket" "secret_data" {
  bucket = "my-aws-secret-production-data-123"

  tags = merge(
    var.resource_tags,
    {
      Name       = "Secret Production Data Bukcet"
      Demo       = "prevent_destroy"
      DataType   = "Secret"
      Compliance = "Required"
    }
  )

  #   # Lifecycle Rule: Prevent accidental deletion of this bucket
  #   # Terraform will throw an error if you try to destroy this resource
  #   # To delete: Comment out prevent_destroy first, then run terraform apply

  lifecycle {
    prevent_destroy = false
  }
}

# # Enabling versioning on the secret bucket

resource "aws_s3_bucket_versioning" "secret_bucket" {
  bucket = aws_s3_bucket.secret_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Task 3: ignore_changes example
# Use Case: Auto Scaling Group where capacity is managed externally

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server"
  image_id      = data.aws_ami.amamzon_linux2.id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.resource_tags,
      {
        Name = "App Srever from ASG"
        Demo = "ignore_changes"
      }
    )
  }
}

# Auto scaling Group
resource "aws_autoscaling_group" "app_servers" {
  name               = "app-servers-asg"
  min_size           = 1
  max_size           = 5
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = data.aws_availability_zones.available.names

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App server from ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Demo"
    value               = "ignore_changes"
    propagate_at_launch = false
  }
  # Lifecycle Rule: Ignore changes to desired_capacity
  # This is useful when auto-scaling policies or external systems modify capacity
  # Terraform won't try to revert capacity changes made outside of Terraform

  lifecycle {
    ignore_changes = [
      desired_capacity
      # also ignore load_balancers if added later by other processes
    ]
  }
}

# Task 4: precondition example
# Use Case: Ensure we're deploying in an allowed region

resource "aws_s3_bucket" "regional_validation" {
  bucket = "validated-region-${var.environment}-${substr(data.aws_region.current.id, 0, 1)}-${substr(aws_instance.web-server.id, -6, 6)}"

  tags = merge(
    var.resource_tags,
    {
      Name = "Regional validated Bucket"
      Demo = "precondition"
    }
  )

  # Lifecycle Rule: Precondition to ensure deployment only in allowed regions
  # If the condition is not met, Terraform will halt the operation with an error message
  # This prevents resource creation in authorized regions
  # Lifecycle Rule: Validate region before creating the resource

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.id)
      error_message = "ERROR: This resource can only be created in allowed regions: ${join(", ", var.allowed_regions)}. Current region is ${data.aws_region.current.id}."
    }
  }
}

# Task 5 : postcondition example
# Use Case: Ensure that the S3 bucket has versioning enabled after creation
resource "aws_s3_bucket" "Compliance_bucket" {
  bucket = "compliance-bucket-${var.environment}-${substr(data.aws_region.current.id, 0, 1)}-${substr(aws_instance.app_with_sg.id, -6, 6)}"

  tags = merge(
    var.resource_tags,
    {
      Name       = "Compliance Validated Bucket"
      Demo       = "postcondition"
      Compliance = "Required"
    }
  )

  # Lifecycle Rule: Validate bucket has required tags after creation
  # This ensures compliance with organizational tagging policies
  # Lifecycle Rule: Postcondition to ensure versioning is enabled
  # If the condition is not met after resource creation, Terraform will throw an error

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "ERROR: Bucket must have a 'Compliance' tag for audit purpose!"
    }

    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "ERROR: Bucket must have an 'Environment' tag!"
    }
  }
}

# replace_triggered_by example
# Use Case: Replace EC2 instance when a specific tag changes

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group chnages
resource "aws_instance" "app_with_sg" {
  ami                    = data.aws_ami.amamzon_linux2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.resource_tags,
    {
      Name = "App Instance with SG"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures that any changes to the security group result in a new instance being created
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}

# Task 7: Multiple S3 buckets with create_before_destroy
# Use Case: Managing multiple buckets from a set
resource "aws_s3_bucket" "app_buckets" {
  for_each = var.bucket_names

  bucket = "${each.value}-${var.environment}"

  tags = merge(
    var.resource_tags,
    {
      Name   = each.value
      Demo   = "for_each_with_lifecycle"
      Bucket = each.value
    }
  )
  # Lifecycle Rule: Create new bucket before destroying old one
  # Useful when renaming buckets or migrating data
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      # Ignore ACL changes if managed by another process
      # acl,
    ]
  }
}

# Example 8: Combining Multiple Lifecycle Rules
# Use Case : DynamoDB table with comprehensive protections

# This example shows how to combine multiple lifecycle rules on a single resource
# DynamoDB is used here because it's simple and doesn't require VPC setup

resource "aws_dynamodb_table" "critical_app_data" {
  name         = "${var.environment}-app-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    var.resource_tags,
    {
      Name        = "Critical Application Data"
      Demo        = "multiple_lifecycle_rules"
      DataType    = "Critical"
      Environment = var.environment
    }
  )

  # Multiple Lifecycle Rules Combined for Production Protection

  lifecycle {

    # Rule 1: Prevent accidental deletion
    # This protects the table from being destroyed accidentally
    # prevent_destroy = true  # COMMENTED OUT TO ALLOW DESTRUCTION

    # Rule 2: Create new resource before destroying old one
    # Ensures zero downtime if table needs to be recreated

    create_before_destroy = true

    # Rule 3: Ignore changes to certain attributes
    # Allow AWS to manage read/write capacity for auto-scaling

    ignore_changes = [

      # Ignore read/write capacity if using auto-scaling
      # read_capacity,
      # write_capacity,

    ]

    # Rule 4: Validate before creation
    precondition {
      condition     = contains(keys(var.resource_tags), "Environment")
      error_message = "Critical table must have Environment tag for compliance!"
    }

    # Rule 5: Validate after creation
    postcondition {
      condition     = self.billing_mode == "PAY_PER_REQUEST" || self.billing_mode == "PROVISIONED"
      error_message = "Billing mode must be either PAY_PER_REQUEST or PROVISIONED!"
    }
  }
}

# RDS requires VPC, subnets, security groups, etc.
# For a simple lifecycle demo, the above DynamoDB example is better
# If you need RDS lifecycle examples, set up VPC resources first