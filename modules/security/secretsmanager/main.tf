resource "aws_secretsmanager_secret" "rds_proxy_secret" {
  name = "${var.name}-rds-proxy-secret"

  tags = merge(var.common_tags, {
    Name = "${var.name}-rds-proxy-secret"
  })
}

resource "aws_secretsmanager_secret_version" "rds_proxy_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_proxy_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}