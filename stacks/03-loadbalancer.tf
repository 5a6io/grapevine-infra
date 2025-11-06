module "alb" {
  source = "terraform-aws-modules"

  name = var.name
  vpc_id = var.vpc_id
  subnets = []

  security_group_ingress_rules = {
    all_http = {
        from_port = 80
        to_port = 80
        ip_protocol = "tcp"
        cidr_ipv4 = "0.0.0.0/0"
    }
    all_https = {
        from_port = 443
        to_port = 443
        ip_protocol = "tcp"
        cidr_ipv4 = "0.0.0.0/0"
    }
  }

  access_logs = {
    bucket = ""
  }

  listeners = {
    ex-http-https-redirec = {

    }
    ex-https = {

    }
  }

  target_groups = {
    ex-instance = {

    }
  }

  tags = {}
}