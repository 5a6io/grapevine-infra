output "task_definition_arns" {
  value = { for k, t in aws_ecs_task_definition.svc_task : k => t.arn}
}

output "cloudwatch_ecs_log_group_arns" {
  value = { for name, lg in aws_cloudwatch_log_group.ecs_log : name => "${lg.arn}:*" }
}