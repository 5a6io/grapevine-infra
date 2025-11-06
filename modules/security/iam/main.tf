resource "aws_iam_role" "this" {
  name = ""
  assume_role_policy = jsondecode({
    Version = ""
    Statement = [
        {
            Action = "sts.AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = ""
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_permissions" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instanceprofile"
  role = aws_iam_role.execution_role.name
}