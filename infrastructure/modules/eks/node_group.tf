resource "aws_eks_node_group" "this" {
  count = var.enable_node_group ? 1 : 0

  cluster_name    = aws_eks_cluster.this[0].name
  node_group_name = "${var.name_prefix}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  lifecycle {
    precondition {
      condition     = !var.enable_node_group || var.enable_cluster
      error_message = "The EKS cluster must be enabled before the managed node group can be created."
    }
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.name_prefix}-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_ecr,
    aws_eks_addon.vpc_cni,
    aws_eks_addon.kube_proxy
  ]
}
