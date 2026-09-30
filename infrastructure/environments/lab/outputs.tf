# Environment-level outputs will be exposed here.

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
