resource "aws_ecs_service" "svc" {
    for_each = var.service_definitions
    name = "${var.name}-${each.key}"
    cluster = var.cluster_arn
    task_definition = var.task_definition_arns[each.key]
    # desired_count = each.value.desired_count
    launch_type = "FARGATE"
    # platform_version = ""
    health_check_grace_period_seconds = lookup(each.value, "health_check_grace_period_seconds", 30)

    network_configuration {
      subnets = var.private_subnet_ids
      security_groups = [ var.sg_ecs_service_ids[each.key] ]
    }

    load_balancer {
      target_group_arn = var.target_group_arns[each.key]
      container_name = each.key
      container_port = each.value.port
    }

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecs-service-${each.key + 1}"
    })
}