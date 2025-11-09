output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_listener_http_arns" {
   value = { for k, v in aws_lb_listener.http_listener : k => v.arn}
}

# output "alb_listener_https_arns" {
#   value = { for k, v in aws_lb_listener.https_listener : k => v.arn }
# }


output "target_groups_blue_arns" {
  value = { for k, tg in aws_lb_target_group.blue : k => tg.arn}
}

output "target_group_green_arns" {
  value = { for k, tg in aws_lb_target_group.green : k => tg.arn}
}