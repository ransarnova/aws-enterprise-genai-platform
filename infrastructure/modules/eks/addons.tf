resource "aws_eks_addon" "pod_identity_agent" {
  count = var.enable_cluster ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.10-eksbuild.3"

  tags = {
    Name = "${var.name_prefix}-pod-identity-agent"
  }
}

resource "aws_eks_addon" "vpc_cni" {
  count = var.enable_cluster ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "vpc-cni"
  addon_version = "v1.22.4-eksbuild.3"

  pod_identity_association {
    service_account = "aws-node"
    role_arn        = aws_iam_role.vpc_cni.arn
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.vpc_cni
  ]

  tags = {
    Name = "${var.name_prefix}-vpc-cni"
  }
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.enable_cluster ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "kube-proxy"
  addon_version = "v1.36.0-eksbuild.48"

  tags = {
    Name = "${var.name_prefix}-kube-proxy"
  }
}

resource "aws_eks_addon" "coredns" {
  count = var.enable_cluster && var.enable_node_group ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "coredns"
  addon_version = "v1.14.7-eksbuild.11"

  tags = {
    Name = "${var.name_prefix}-coredns"
  }
}
