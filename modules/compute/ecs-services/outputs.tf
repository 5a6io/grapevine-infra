output "service_names" {
  description = "ECS Service Name per service (map)"
  value = { for k, svc in aws_aws_ecs_service.this : k => svc.name}
}

output "service_arns" {
  description = "ECS Service ARN per service (map)"
  value = { for k, svc in aws_ecs_service.this : k => svc.arn }
}