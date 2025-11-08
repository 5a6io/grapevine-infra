variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "target_group_blue" {
  type = map(string)
}

variable "target_group_green" {
  type = map(string)
}

variable "lb_listener_arns" {
  type = map(string)
}

variable "services" {
  type = map(object({
    port = number
    paths = list(string)
    cpu = optional(number)
    memory = optional(number)
    image = optional(string)
    desired_count = optional(number, 1)
  }))
}

variable "ecs_cluster_name" {
  type = string
}

variable "codedeploy_role_arn" {
  type = string
}

variable "ecs_service" {
  type = map(string)
}