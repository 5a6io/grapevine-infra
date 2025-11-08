resource "aws_cloudwatch_log_group" "ecs_log" {
  for_each = var.service_definitions
  name     = "/ecs/${var.name}/${each.key}"
  retention_in_days = each.value.log_retention

  tags = merge(var.common_tags, {
    Name = "${var.name}-${each.key}-ecs-logs"
  })
}

resource "aws_ecs_task_definition" "svc_task" {
    for_each = var.service_definitions

    family = "${var.name}-${each.key}"
    requires_compatibilities = [each.value.launch_type]
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
                    awslogs-group = aws_cloudwatch_log_group.ecs_log[each.key].name
                    awslogs-region = var.region
                    awslogs-stream-prefix = each.key
                }
            }

            environment = [
            for k, v in var.environment : {
                name  = k
                value = v
            }
            ]
        }
    ])

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecs-task-definition"
    })
}