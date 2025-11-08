resource "aws_codedeploy_app" "this" {
    name = "${var.name}-codedeploy" 
    compute_platform = "ECS"

    tags = merge(var.common_tags, {
        Name = "${var.name}-codedeploy"
    })
}

resource "aws_codedeploy_deployment_config" "this" {
    deployment_config_name = "${var.name}-deployment-config"
    compute_platform = "ECS"

    traffic_routing_config {
        type = "TimeBasedCanary"

        time_based_canary {
            percentage = 10 # 새 버전에 10% 트래픽 먼저 보냄
            interval = 5 # 5분 후 나머지 90% 전환
        }
    }
}

resource "aws_codedeploy_deployment_group" "this" {
  for_each = var.services

  app_name = aws_codedeploy_app.this.name
  deployment_group_name = "${var.name}-${each.key}-codedeploy-group"
  deployment_config_name = aws_codedeploy_deployment_config.this.deployment_config_name
  service_role_arn = var.codedeploy_role_arn

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service[each.key]
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.target_group_blue[each.key]
      }
      target_group {
        name = var.target_group_green[each.key]
      }
      prod_traffic_route {
        listener_arns = [ var.lb_listener_arns[each.key] ]
      }
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.name}-${each.key}-codedeploy-group"
  })
}