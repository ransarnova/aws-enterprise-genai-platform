data "aws_iam_policy_document" "eks_admin_trust" {
  statement {
    sid     = "AllowAuthorizedAdminRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.admin_trusted_role_arn]
    }
  }
}

resource "aws_iam_role" "eks_admin" {
  name               = "${var.name_prefix}-eks-admin-role"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_trust.json

  tags = {
    Name = "${var.name_prefix}-eks-admin-role"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "eks_admin_permissions" {
  statement {
    sid    = "DescribeEKSCluster"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      "arn:aws:eks:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
    ]
  }
}

resource "aws_iam_role_policy" "eks_admin" {
  name   = "${var.name_prefix}-eks-admin-policy"
  role   = aws_iam_role.eks_admin.id
  policy = data.aws_iam_policy_document.eks_admin_permissions.json
}
