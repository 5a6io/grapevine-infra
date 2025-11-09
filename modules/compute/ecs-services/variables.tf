variable "name" {
    type = string
}
variable "region" {
    type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "cluster_arn" {
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
    desired_count = optional(number, 1)
  }))
}

variable "task_definition_arns" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "sg_ecs_service_ids" {
  type = map(string)
}