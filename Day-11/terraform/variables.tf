variable "project_name" {
    default = "Project ALPHA Resource"
}

variable "default_tags" {
    default = {
        company = "TechCop"
        managed_by = "Terraform"
    }
}

variable "environment_tags" {
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

variable "bucket_name" {
  default = "ProjectAlphaStorageBucket with CAPS and spaces!!!!"
}

variable "allowed_ports" {
  default = "80,443,8080"
}

variable "instance_sizes" {
  default = {
    dev = "t2.micro"
    staging = "t3.small"
    prod = "t3.large"
  }
}

variable "environment" {
  default = "dev"
}