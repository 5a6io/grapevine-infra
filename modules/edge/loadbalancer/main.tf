resource "aws_lb" "this" {
  name = "${var.name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.sg_alb_id ]
  subnets = var.subnet_ids

  enable_deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "${var.name}-alb"
  })
}

resource "aws_lb_listener" "http_listener" {
  for_each = var.services
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port = 443
  #     protocol = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue[each.key].arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.name}-lb-http-listener"
  })
}

# resource "aws_lb_listener" "https_listener" {
#   for_each = var.services
#   load_balancer_arn = aws_lb.this.arn
#   port  = 443
#   protocol = "HTTPS"
#   ssl_policy = "ELBsecurity-2016-08"
#   certificate_arn = var.alb_certificate_arn
  
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.blue[each.key].arn
#   }

#   tags = merge(var.common_tags, {
#     Name = "${var.name}-lb-https-listener"
#   })
# }

resource "aws_lb_listener_rule" "this" {
    # for_each = var.alb_certificate_arn != null ? var.services : {}
    # listener_arn = aws_lb_listener.https_listener[each.key].arn
    listener_arn = aws_lb_listener.http_listener.arn
    priority = index(local.service_keys, each.key) + 1
  
    condition {
        path_pattern {
        values = each.value.paths
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.blue[each.key].arn
    }

    tags = merge(var.common_tags, {
        Name = "${var.name}-lb-rule"
    })
}

resource "aws_lb_target_group" "blue" {
    for_each = var.services
    name = "${var.name}-${each.key}-blue-tg"
    port = each.value.port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = var.target_type

    health_check {
        enabled = true
        healthy_threshold = 2
        interval = 30
        matcher = "200"
        path = var.health_check_path
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
    }

    tags = merge(var.common_tags, {
        Name = "${var.name}-${each.key}-blue-tg"
    })
}


resource "aws_lb_target_group" "green" {
  for_each = var.services
  name = "${var.name}-${each.key}-green-tg"
  port = each.value.port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = var.target_type

  health_check {
        enabled = true
        healthy_threshold = 2
        interval = 30
        matcher = "200"
        path = var.health_check_path
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 2
    }

    tags = merge(var.common_tags, {
        Name = "${var.name}-${each.key}-green-tg"
    })

}

locals {
  service_keys = sort(keys(var.services))
}