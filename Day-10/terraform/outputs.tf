# Conditional Expression Outputs

output "conditional_instance_type" {
  description = "Instance type selected based on environment (prod=t3.large, dev=t2.micro)"
  value = aws_instance.conditional_example.instance_type
}

output "conditional_instance_id" {
  description = "Instance ID of the conditional example"
  value = aws_instance.conditional_example.id
}

# Dynamic Block Outputs

output "dynamic_sg_id" {
  description = "Security group ID with dynamic rules"
  value       = aws_security_group.dynamic_sg.id
}

output "security_group_rules_count" {
  description = "Number of ingress rules created dynamically"
  value       = length(var.ingress_rules)
}


# Splat Expression Outputs

output "all_instance_ids" {
  description = "All instance IDs using splat expression [*]"
  value       = aws_instance.splat_example[*].id
}

output "all_private_ips" {
  description = "All private IPs using splat expression [*]"
  value       = aws_instance.splat_example[*].private_ip
}
