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
    cpu = string
    memory = string
    image = string
    env_map = optional(map(string))
  }))
}

variable "environment" {
  type = list(string)
  default = [  ]
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arns" {
  type = map(string)
}

variable "ecs_log_group_arns" {
  type = map(string)
}