# Infrastructure modules will be composed here.
data "aws_availability_zones" "available" {
  state = "available"
}

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

  enable_cluster         = var.enable_eks
  cluster_name           = "${local.name_prefix}-eks"
  kubernetes_version     = var.eks_kubernetes_version
  private_subnet_ids     = module.networking.private_subnet_ids
  admin_trusted_role_arn = var.eks_admin_trusted_role_arn
  endpoint_public_access = var.eks_endpoint_public_access
  public_access_cidrs    = var.eks_public_access_cidrs
}

module "admin_host" {
  source = "../../modules/admin_host"

  name_prefix = local.name_prefix
}
