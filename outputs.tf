# Output variable definitions

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances_public.public_ip
}

output "ec2_instance_private_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances_private.private_ip
}
