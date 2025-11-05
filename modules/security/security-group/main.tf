# RDS
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  vpc_id      = var.vpc_id
  tags        = merge(var.common_tags, {
    Name = "${var.name}-rds-sg"
  })
}

resource "aws_security_group" "rds_proxy" {
  name = "${var.name}-rds-proxy-sg"
  vpc_id = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.name}-rds-proxy-sg"
  })
}

# ECS -> RDS Proxy
resource "aws_vpc_security_group_ingress_rule" "rds_proxy_rds" {
  security_group_id = aws_security_group.rds_proxy.id
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_ipv4 = "0.0.0.0/0"
#   referenced_security_group_id = aws_security_group.ecs.id
}

# RDS Proxy -> RDS
resource "aws_vpc_security_group_ingress_rule" "rds_from_rds_proxy" {
  security_group_id            = aws_security_group.rds.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.rds_proxy.id
}

resource "aws_vpc_security_group_egress_rule" "rds_all_out" {
  security_group_id = aws_security_group.rds.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "rds_proxy_all_out" {
  security_group_id = aws_security_group.rds_proxy.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}