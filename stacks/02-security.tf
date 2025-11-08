# SG
module "sg" {
  source          = "../modules/security/security-group"
  name            = var.name
  common_tags     = var.common_tags
  vpc_id          = module.vpc.vpc_id
  services = var.services
}

#IAM
module "iam" {
  source = "../modules/security/iam"
  name = var.name
  common_tags = var.common_tags
  services = var.services
}

# secretsmanager
module "secretsmanager" {
  source = "../modules/security/secretsmanager"
  name = var.name
  common_tags = var.common_tags
  db_username = var.db_username
  db_password = var.db_password
}