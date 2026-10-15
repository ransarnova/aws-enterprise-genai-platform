# Environment-level outputs will be exposed here.

output "vpc_id" {
  description = "ID of the lab VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the lab public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the lab private subnets."
  value       = module.networking.private_subnet_ids
}

output "availability_zones" {
  description = "Availability Zones used by the lab VPC."
  value       = module.networking.availability_zones
}

output "public_route_table_id" {
  description = "ID of the lab public route table."
  value       = module.networking.public_route_table_id
}

output "private_route_table_ids" {
  description = "IDs of the lab private route tables."
  value       = module.networking.private_route_table_ids
}

output "s3_gateway_endpoint_id" {
  description = "ID of the lab S3 Gateway Endpoint."
  value       = module.networking.s3_gateway_endpoint_id
}

output "dynamodb_gateway_endpoint_id" {
  description = "ID of the lab DynamoDB Gateway Endpoint."
  value       = module.networking.dynamodb_gateway_endpoint_id
}

output "regional_nat_gateway_id" {
  description = "Regional NAT Gateway ID, if enabled."
  value       = module.networking.regional_nat_gateway_id
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane."
  value       = module.eks.cluster_role_arn
}

output "eks_admin_role_arn" {
  description = "Dedicated IAM role used for EKS administration."
  value       = module.eks.eks_admin_role_arn
}

output "admin_host_instance_profile_name" {
  description = "IAM instance profile for the private administration host."
  value       = module.admin_host.instance_profile_name
}
