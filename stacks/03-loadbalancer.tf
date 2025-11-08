module "acm" {
  source = "../modules/edge/acm"
  name = var.name
  common_tags = var.common_tags

  private_key = var.private_key
  certificate_body = var.certificate_body
}

module "alb" {
  source = "../modules/edge/loadbalancer"
  name = var.name
  common_tags = var.common_tags

  vpc_id = module.vpc.vpc_id
  target_type = "ip"
  subnet_ids = module.subnet.private_subnet_ids
  sg_alb_id = module.sg.alb
  health_check_path = var.health_check_path
  services = module.ecs_service.service_arns
  alb_certificate_arn = data.rsa
}

data "acm_arn" "rsa" {
  types = ["AMAZON_ISSUED"]
  most_recent = true
}