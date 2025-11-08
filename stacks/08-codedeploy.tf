module "codedeploy" {
  source = "../modules/cicd/codedeploy"
  name = var.name
  common_tags = var.common_tags

  target_group_blue = module.alb.target_groups_blue_arns
  target_group_green = module.alb.target_group_green_arns
  lb_listener_arns = module.alb.alb_listener_https_arns
  
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  services = module.ecs_service.service_names
  codedeploy_role_arn = module.iam.codedeploy_role
}