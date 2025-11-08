output "sg_rds_id" {
  description = "Rds Security Group ID"
  value       = aws_security_group.rds.id
}

output "sg_rds_proxy_id" {
  description = "Rds Proxy Security Group ID"
  value = aws_security_group.rds_proxy.id
}

output "sg_vpce_id" {
  description = "Vpc Endpoint Security Group ID"
  value = aws_security_group.vpc_endpoint_sg.id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_ecs_service_id" {
  value = aws_security_group.ecs_service.id
}

output "sg_ec2_instance_id" {
  value = aws_security_group.ec2_instance.id
}

output "sg_ecs_id" {
  value = aws_security_group.ecs.id
}