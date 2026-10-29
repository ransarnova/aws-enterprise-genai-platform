
data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowEKSPodIdentity"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks-cluster-name"
      values   = [var.cluster_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = [var.namespace]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = [var.service_account]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "${var.name_prefix}-api-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name = "${var.name_prefix}-api-role"
  }
}

data "aws_iam_policy_document" "bedrock" {
  statement {
    sid       = "AllowBedrockInference"
    effect    = "Allow"
    actions   = ["bedrock:InvokeModel"]
    resources = var.bedrock_resource_arns
  }

  statement {
    sid       = "AllowKnowledgeBaseRetrieval"
    effect    = "Allow"
    actions   = ["bedrock:Retrieve"]
    resources = [var.knowledge_base_arn]
  }
}

resource "aws_iam_role_policy" "bedrock" {
  name   = "${var.name_prefix}-bedrock-invoke"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.bedrock.json
}

resource "aws_eks_pod_identity_association" "app" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account
  role_arn        = aws_iam_role.app.arn

  depends_on = [
    aws_iam_role_policy.bedrock
  ]
}
