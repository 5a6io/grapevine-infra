resource "aws_service_discovery_private_dns_namespace" "svc" {
    name = var.namespace
    vpc = var.vpc_id
    tags = merge(var.common_tags, {
        Name = "${var.name}-svc-dns-ns"
    })
}

resource "aws_ecs_cluster" "this" {
    name = "${var.name}-ecs-cluster"

    depends_on = [ 
        aws_ecs_capacity_provider.ec2
     ]

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


resource "aws_ecs_capacity_provider" "ec2" {
    count = var.enable_ec2 ? 1 : 0

    name = "${var.name}-ec2-capacity"

    auto_scaling_group_provider {
        auto_scaling_group_arn = aws_autoscaling_group.this[0].arn
        managed_termination_protection = "DISABLED"
        managed_scaling {
          status = "ENABLED"
          target_capacity = 100
        }
    }  
}

resource "aws_ecs_cluster_capacity_providers" "this" {
    cluster_name = aws_ecs_cluster.this.name

    capacity_providers = [ 
      var.enable_fargate ? "FARGATE" : null,
      var.enable_fargate ? "FARGATE_SPOT" : null,
      var.enable_ec2 ? aws_ecs_capacity_provider.ec2[0].name : null
    ]

    default_capacity_provider_strategy {
      capacity_provider = var.enable_fargate ? "FARGATE" : aws_ecs_capacity_provider.ec2[0].name
      weight = 1
    }
}

resource "aws_launch_template" "this" {
  for_each = var.enable_ec2 ? var.services : 0
  
  name = "${var.name}-${each.key}-lt"
  image_id = data.aws_ssm_parameter.ami.value

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 50
      delete_on_termination = true
    }
  }
  
  update_default_version = true
  iam_instance_profile {
    arn = var.instance_profile_arn
  }
  
  instance_type = var.instance_type
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [ var.ecs_instance_sg_ids[each.key].id ]

   user_data = base64encode(templatefile("${path.module}/ecs_user_data.sh", {
    cluster_name = aws_ecs_cluster.name
   }))
}

resource "aws_autoscaling_group" "this" {
  for_each = enable_ec2 ? var.services : 0

  name = "${var.name}-${each.key}-asg"
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  protect_from_scale_in = true
  # list of subnet ids to launch the instances in private subnets
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id = aws_launch_template.this[each.key].id
    version = "$Latest"
  }
}

# EC2 실행 시 필요한 기본 이미지
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}