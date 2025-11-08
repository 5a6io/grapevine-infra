output "ecs_task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_instance_role" {
  value = aws_iam_role.ecs_instance_role.arn
}

output "codedeploy_role" {
  value = aws_iam_role.codedeploy_role.arn
}