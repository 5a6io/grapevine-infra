variable "name" {
    type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type = string
}

variable "service_definitions" {
  type = map(object({
    port = number
    ingress_from = string
    egress = list(object({
      to = string
      port = number
    }))
    launch_type  = optional(string, "FARGATE")
    cpu = string
    memory = string
    image = string
    env_map = map(string)
    log_retention = number
  }))
}

variable "environment" {
  description = "Default environment variables for ECS containers"
  type        = map(string)
  default = {
    SPRING_PROFILES_ACTIVE = "dev"
    AWS_REGION             = "ap-northeast-2"
    TZ                     = "Asia/Seoul"
  }
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arns" {
  type = map(string)
}

# variable "ecs_log_group_names" {
#   type = map(string)
# }

# variable "log_groups" {
#   type = map(object({
#     retention = number
#   }))
# }