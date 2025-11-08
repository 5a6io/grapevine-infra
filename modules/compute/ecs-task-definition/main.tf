resource "aws_ecs_task_definition" "svc_task" {
    for_each = var.service_definitions

    family = "${var.name}-${each.key}"
    requires_compatibilities = each.value.launch_type
    cpu = each.value.cpu
    memory = each.value.memory
    network_mode = each.value.launch_type == "FARGATE" ? "awsvpc" : "bridge"

    execution_role_arn = var.ecs_task_execution_role_arn
    task_role_arn = try(var.ecs_task_role_arns[each.key], null)

    runtime_platform {
      operating_system_family = "LINUX"
    }

    container_definitions = jsonencode([
        {
            name = each.key
            image = each.value.image
            essential = true

            portMappings = [
                {
                    containerPort = each.value.port
                    hostPort = each.value.port
                    protocol = "tcp"
                    name = each.key
                }
            ]

            # Cloud Watch Logs
            log_configuration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group = var.ecs_log_group_arns[each.key]
                    awslogs-region = var.region
                    awslogs-stream-prefix = each.key
                }
            }

            environment = var.environment
        }
    ])

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecs-task-definition"
    })
}