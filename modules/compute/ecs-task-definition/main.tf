data "aws_secretsmanager_secret" "this" {
  for_each = va
}

resource "aws_ecs_task_definition" "svc_task" {
    for_each = var.service_definitions
    family = "${var.name}-${each.key}"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = each.value.cpu
    memory = each.value.memory

    execution_role_arn = var.ecs_task_execution_role_arn
    task_role_arn = var.ecs_task_role_arns[each.key]

    runtime_platform {
      operating_system_family = "LINUX"
    }

    container_definitions = jsondecode([
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
            log_configuration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group = aws_cloudwatch_log_group.svc[each.key].name
                    awslogs-region = var.region
                    awslogs-stream-prefix = each.key
                }
            }

            environment = concat(
                [
                    
                ]
            )

            secrets = [
                for key_name in lookup(each.value, "secret_keys", []) : {
                    name = key_name
                    valueFron = data.aws_secretmanager_secret.this[key_name].arn
                }
            ]
        }
    ])

    tags = merge(var.common_tags, {
        Name = "${var.name}"
    })
}