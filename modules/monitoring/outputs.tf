output "cloudwatch_dashboard_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.this.dashboard_name}"
}

output "cloudwatch_ecs_log_group_names" {
  value = { for k, v in aws_cloudwatch_log_group.ecs_log : k => v.name}
}

output "cloudwatch_ecs_log_group_arns" {
  value = { for name, lg in aws_cloudwatch_log_group.ecs_log : name => lg.arn }
}

output "cloudwatch_waf_log_group_name" {
  value = aws_cloudwatch_log_group.waf_log.name
}

output "cloudwatch_waf_log_group_arn" {
  value = aws_cloudwatch_log_group.waf_log.arn
}

# output "cloudwatch_alarm_names" {
#   value = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.alarm_name}
# }
