output "cloudwatch_dashboard_url" {
  value = "https://${var.region}.consol.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.this.dashboard_name}"
}

output "cloudwatch_log_group_names" {
  value = { for k, v in aws_aws_cloudwatch_log_group.this : k => v.name}
}

output "cloudwatch_alarm_names" {
  value = { for k, v in aws_aws_cloudwatch_metric_alarm.this : k => v.alarm_name}
}