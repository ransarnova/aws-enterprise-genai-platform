
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2,
  )

  name_prefix = "${var.project_name}-${var.environment}"
}

module "networking" {
  source = "../../modules/networking"

  name_prefix = local.name_prefix

  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway

}

module "eks" {
  source = "../../modules/eks"

  name_prefix = local.name_prefix

  enable_cluster          = var.enable_eks
  cluster_name            = "${local.name_prefix}-eks"
  kubernetes_version      = var.eks_kubernetes_version
  private_subnet_ids      = module.networking.private_subnet_ids
  admin_trusted_role_arn  = var.eks_admin_trusted_role_arn
  endpoint_public_access  = var.eks_endpoint_public_access
  public_access_cidrs     = var.eks_public_access_cidrs
  enable_node_group       = var.enable_eks_node_group
  console_viewer_role_arn = var.eks_console_viewer_role_arn
}

module "admin_host" {
  source = "../../modules/admin_host"

  name_prefix = local.name_prefix
}


module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${local.name_prefix}-api"
}


module "app_identity" {
  source = "../../modules/app_identity"

  name_prefix        = local.name_prefix
  cluster_name       = module.eks.cluster_name
  namespace          = "genai-platform"
  service_account    = "genai-platform-api"
  knowledge_base_arn = module.knowledge_base.knowledge_base_arn

  bedrock_resource_arns = [
    "arn:${data.aws_partition.current.partition}:bedrock:ap-south-1:${data.aws_caller_identity.current.account_id}:inference-profile/apac.amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-south-1::foundation-model/amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-southeast-1::foundation-model/amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-southeast-2::foundation-model/amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-northeast-1::foundation-model/amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-northeast-2::foundation-model/amazon.nova-micro-v1:0",
    "arn:aws:bedrock:ap-northeast-3::foundation-model/amazon.nova-micro-v1:0"
  ]
}

module "knowledge_base" {
  source = "../../modules/knowledge_base"

  name_prefix          = local.name_prefix
  policy_document_path = "${path.root}/../../../knowledge-base/documents/lending-policy.txt"
}


module "load_balancer_controller" {
  source = "../../modules/load_balancer_controller"

  name_prefix     = local.name_prefix
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
}


module "api_gateway" {
  count  = var.enable_api_gateway ? 1 : 0
  source = "../../modules/api_gateway"

  name_prefix           = local.name_prefix
  vpc_id                = module.networking.vpc_id
  vpc_cidr              = module.networking.vpc_cidr
  private_subnet_ids    = module.networking.private_subnet_ids
  nlb_name              = var.internal_nlb_name
  cognito_user_pool_arn = module.cognito.user_pool_arn
}

module "cognito" {
  source = "../../modules/cognito"

  name_prefix = local.name_prefix

}
