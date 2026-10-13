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
