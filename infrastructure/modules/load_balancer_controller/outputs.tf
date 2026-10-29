
output "role_arn" {
  description = "IAM role ARN used by AWS Load Balancer Controller."
  value       = aws_iam_role.controller.arn
}

output "policy_arn" {
  description = "IAM policy ARN for AWS Load Balancer Controller."
  value       = aws_iam_policy.controller.arn
}
