
# VPC
module "vpc" {
  source          = "../modules/network/vpc"
  name            = var.name
  common_tags     = var.common_tags
  vpc_cidr        = var.vpc_cidr
}

# Subnet
module "subnets" {
  source          = "../modules/network/subnets"
  name            = var.name
  common_tags     = var.common_tags
  vpc_id          = module.vpc.vpc_id
  availability_zones   = var.availability_zones
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

# IGW / NAT
module "igw_nat" {
  source                = "../modules/network/igw-nat"
  name                 = var.name
  common_tags          = var.common_tags
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  multi_nat            = var.multi_nat
}