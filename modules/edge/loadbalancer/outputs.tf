output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_listener_https_arn" {
  value = aws_lb_listener.https_listener.arn
}

output "target_groups_blue_arns" {
  value = { for k, tg in aws_aws_lb_target_group.blue : k => tg.arn}
}

output "target_group_green_arns" {
  value = { for k, tg in aws_aws_lb_target_group.green : k => tg.arn}
}