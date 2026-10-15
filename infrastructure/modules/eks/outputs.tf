output "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane."
  value       = aws_iam_role.cluster.arn
}

output "eks_admin_role_arn" {
  description = "ARN of the dedicated EKS administrator IAM role."
  value       = aws_iam_role.eks_admin.arn
}
