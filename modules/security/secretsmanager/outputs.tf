output "rds_proxy_secret_arn" {
  value = aws_secretsmanager_secret.rds_proxy_secret.arn
}
