output "task_definition_arns" {
  value = { for k, t in aws_ecs_task_definition.svc_task : k => t.arn}
}