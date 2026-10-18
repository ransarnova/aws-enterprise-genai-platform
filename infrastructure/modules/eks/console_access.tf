resource "aws_eks_access_entry" "console_viewer" {
  count = var.enable_cluster && var.console_viewer_role_arn != null ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  principal_arn = var.console_viewer_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "console_viewer" {
  count = var.enable_cluster && var.console_viewer_role_arn != null ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  principal_arn = aws_eks_access_entry.console_viewer[0].principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"

  access_scope {
    type = "cluster"
  }
}
