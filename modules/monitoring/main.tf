resource "aws_cloudwatch_log_group" "this" {
  for_each = var.log_groups
  name = "/ecs/${each.key}"
  retention_in_days = each.value.retention

  tags = merge( var.common_tags, {
    Name = "${var.name}-${each.key}-log-group"
  })
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name}-dashboard"

  dashboard_body = jsondecode({
    widgets = [
        {
            "type" = "metric",
            "x" = 0
            "y" = 0
            "width" = 12
            "height" = 6
            "properties" = {
                "metrics" = [
                    ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "api"],
                    [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "api"]
                ],
                "period" = 300,
                "stat" = "Average"
                "region" = var.region
                "title" = "ECS Service Metrics"
            }
        },
        {
            "type" = "log",
            "x" = 0,
            "y" = 0,
            "width" = 24,
            "height" = 6,
            "properties" = {
                "query" = "fields @timestamp, @message | filter @message like /ERROR/ | stats count() by bin(5m)",
                "region" = var.region
                "logGroupNames" = ["/ecs/api"],
                "title" = "ECS Error Logs(5m)"
            }
        }
    ]
  })
}