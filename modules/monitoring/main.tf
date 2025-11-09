resource "aws_cloudwatch_log_group" "ecs_log" {
  for_each = var.log_groups
  name = "/ecs/${each.key}"
  retention_in_days = each.value.retention

  tags = merge( var.common_tags, {
    Name = "${var.name}-${each.key}-log-group"
  })
}

resource "aws_cloudwatch_log_group" "waf_log" {
  name = "/aws/waf/${var.name}"
  retention_in_days = 30
  tags = merge(var.common_tags, {
    Name = "${var.name}-waf-log-group"
  })
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name}-dashboard"

  dashboard_body = jsonencode({
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

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_document = data.aws_iam_policy_document.example.json
  policy_name = "webacl-policy-uniq-name"
}

data "aws_iam_policy_document" "example" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = concat(local.waf_log_group_arns, local.ecs_log_group_arns)
  }
}

locals {
  # CloudWatch WAF Log Groups → ARN + ":*" 형식으로 변환
  waf_log_group_arns = [
    for name, lg in aws_cloudwatch_log_group.waf_log :
    "${lg.arn}:*"
  ]

  # ECS 로그 그룹은 var로 받은 map(string)이므로 그대로 values() 사용 가능
  ecs_log_group_arns = [
    for _, arn in var.cloudwatch_ecs_log_group :
    "${arn}"
  ]
}