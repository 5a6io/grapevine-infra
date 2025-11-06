module "alb" {
  source = "../modules/edge/loadbalancer"
  name = var.name
  common_tags = var.common_tags

  vpc_id = module.vpc.vpc_id
  target_type = ""
  subnet_ids = module.subnet.private_subnet_ids
  sg_alb_id = module.sg.alb
  health_check_path = var.health_check_path
  services = var.services
  alb_certificate_arn = ""
}