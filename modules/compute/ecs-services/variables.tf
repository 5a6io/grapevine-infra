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
    }))
}

variable "cluster_arn" {
  type = string
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

variable "target_group_arns" {
  type = map(string)
}