output "codedeploy_app_name" {
  value = aws_codedeploy_app.this.name
}

output "aws_codedeploy_deployment_group_name" {
 value = { for k, v in aws_codedeploy_deployment_group.this : k => v.deployment_group_name}
}