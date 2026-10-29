
output "vpc_link_id" {
  description = "VPC Link V2 ID."
  value       = aws_apigatewayv2_vpc_link.this.id
}

output "vpc_link_arn" {
  description = "VPC Link V2 ARN."
  value       = aws_apigatewayv2_vpc_link.this.arn
}

output "security_group_id" {
  description = "VPC Link security group ID."
  value       = aws_security_group.vpc_link.id
}

output "nlb_arn" {
  description = "ARN of the existing Kubernetes-managed internal NLB."
  value       = data.aws_lb.internal.arn
}
output "health_url" {
  description = "REST API health endpoint URL."
  value       = "${aws_api_gateway_stage.lab.invoke_url}/api/v1/health"
}
