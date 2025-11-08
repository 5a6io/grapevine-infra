# SG
module "sg" {
  source          = "../modules/security/security-group"
  name            = var.name
  common_tags     = var.common_tags
  vpc_id          = module.vpc.vpc_id
}

# WAF
module "waf" {
  source = "../modules/security/waf"
  name = var.name
  common_tags = var.common_tags
  alb_arn = module.alb.alb_arn
  waf_log_group_arn = module.cloudwatch.cloudwatch_waf_log_group_arn
}

#IAM
module "iam" {
  source = "../modules/security/iam"
  name = var.name
  common_tags = var.common_tags
}