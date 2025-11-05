resource "aws_service_discovery_private_dns_namespace" "svc" {
    name = var.namespace
    vpc = var.vpc_id
    tags = merge(var.common_tags, {
        Name = "${var.name}-svc-discovery-private-dns-ns"
    })
}

resource "aws_ecs_cluster" "this" {
    name = "${var.name}-ecs-cluster"

    setting {
      name = "containerInsights"
      value = "enabled"
    }

    service_connect_defaults {
      namespace = aws_service_discovery_private_dns_namespace.svc.arn
    }

    tags = merge(var.common_tags, {
        Name = "${var.name}-ecs-cluster"
    })
}

resource "aws_ecs_cluster_capacity_providers" "this" {
    cluster_name = aws_ecs_cluster.this.name
    capacity_providers = [ aws_ecs_capacity_provider.this.name ]

    default_capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.this.name
        weight = 1
        base = 0
    }
}