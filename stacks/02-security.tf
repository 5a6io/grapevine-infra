# SG
module "sg" {
  source          = "../modules/security/security-group"
  name            = var.name
  common_tags     = var.common_tags
  vpc_id          = module.vpc.vpc_id
}