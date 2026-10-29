
output "role_arn" {
  description = "IAM role ARN assigned to the FastAPI application."
  value       = aws_iam_role.app.arn
}

output "association_id" {
  description = "EKS Pod Identity association ID."
  value       = aws_eks_pod_identity_association.app.association_id
}
