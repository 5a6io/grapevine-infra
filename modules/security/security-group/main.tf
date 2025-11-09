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

# VPC Endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "${var.name}-vpce-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.name}-vpce-sg"
  })
}

# ECS
resource "aws_security_group" "ecs" {
  name = "${var.name}-ecs-sg"
  vpc_id = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.name}-ecs-sg"
  })
}

resource "aws_security_group" "ec2_instance" {
  for_each = var.services

  name = "${var.name}-${each.key}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = each.value.port
    to_port = each.value.port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, {
    Name = "${var.name}-ec2-sg"
  })
}

# resource "aws_security_group" "ecs_service" {
#   for_each = var.services

#   name = "${var.name}-${each.key}-sg"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port = each.value.port
#     to_port = each.value.port
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = merge(var.common_tags, {
#     Name = "${var.name}-ecs-service-sg"
#   })
# }

# ALB
resource "aws_security_group" "alb" {
  name = "${var.name}-alb-sg"
  vpc_id = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.name}-alb-sg"
  })
}

# ALB -> ECS
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}