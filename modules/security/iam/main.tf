# Related ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecs-task-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts.AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ecs-tasks.amazonaws.com"
            }
        }
    ]
  })

  tags = merge(var.common_tags, {
    name = "${var.name}-ecs-task-execution-role"
  })
}

resource "aws_iam_role" "ecs_task_role" {
  for_each = var.services
  name = "${var.name}-${each.key}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, {
    name = "${var.name}-ecs-task-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.name}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = merge(var.common_tags, {
    name = "${var.name}-ecs-instance-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_permissions" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ecs_instance_role.name

  tags = merge(var.common_tags, {
    name = "${var.name}-instance-profile"
  })

}

# Related CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.name}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "codedeploy.amazonaws.com"}
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForECS"
}

# rds
resource "aws_iam_role" "rds_proxy_role" {
  name = "${var.name}-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.name}-rds-proxy-role"
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_secrets_access" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}