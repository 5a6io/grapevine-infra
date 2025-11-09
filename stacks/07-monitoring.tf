module "cloudwatch" {
  source = "../modules/monitoring"
  name = var.name
  common_tags = var.common_tags

  region = var.region
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  log_groups = var.log_groups
  cloudwatch_ecs_log_group = module.ecs_task_definition.cloudwatch_ecs_log_group_arns
}