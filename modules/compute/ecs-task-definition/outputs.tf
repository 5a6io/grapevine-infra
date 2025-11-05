output "ecs_task" {
  value = aws_ecs_task_definition.task.family[*]
}