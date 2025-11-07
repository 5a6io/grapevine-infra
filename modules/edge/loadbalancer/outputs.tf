output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_groups_arns" {
  value = { for k, tg in aws_aws_lb_target_group.this : k => tg.arn}
}