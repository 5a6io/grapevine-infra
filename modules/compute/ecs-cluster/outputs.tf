output "ecs_cluster_name" {
    value = aws_ecs_cluster.this.name
}

output "namespace" {
    value = aws_service_discovery_private_dns_namespace.svc.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this.arn
}