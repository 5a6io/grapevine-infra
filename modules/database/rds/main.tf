# RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.common_tags, {
    Name = "${var.name}-rds-subnets"
  })
}

# RDS parameter group
resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-rds-pg"
  family = "mysql${var.engine_version}"

  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8_general_ci"
  }

    parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
  }
  
  tags       = merge(var.common_tags, {
    Name = "${var.name}-rds-pg"
  })
}

# RDS Instance
resource "aws_db_instance" "this" {
  identifier              = "${var.name}-rds"
  engine                  = "mysql"
  db_subnet_group_name    = aws_db_subnet_group.this.name
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  backup_retention_period = var.rds_backup_day
  allocated_storage       = 10
  storage_type            = "gp3"
  multi_az                = true
  publicly_accessible     = false
  storage_encrypted       = true
  apply_immediately       = true
  skip_final_snapshot     = true
  parameter_group_name = aws_db_parameter_group.this.name
  vpc_security_group_ids  = [var.sg_rds_id]
  tags                    = merge(var.common_tags, {
    Name = "${var.name}-rds"
  })
}

# RDS Proxy
resource "aws_db_proxy" "this" {
  name                   = "${var.name}-rds-proxy"
  # debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = var.proxy_idle_client_timeout
  require_tls            = true
  role_arn               = var.proxy_role_arn
  vpc_security_group_ids = [var.sg_rds_proxy_id]
  vpc_subnet_ids         = var.private_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = var.rds_proxy_secret_arn
  }

  tags       = merge(var.common_tags, {
    Name = "${var.name}-rds-proxy"
  })

  depends_on = [
    aws_db_instance.this
  ]
}

# RDS Proxy Target Group
resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

# RDS Proxy Target
resource "aws_db_proxy_target" "this" {
  db_proxy_name          = aws_db_proxy.this.name
  target_group_name      = "default"
  db_instance_identifier = aws_db_instance.this.identifier
}