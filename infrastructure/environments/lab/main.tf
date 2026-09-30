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
}
