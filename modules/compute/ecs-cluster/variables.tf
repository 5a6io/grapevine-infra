variable "name" {
    type = string
}

variable "common_tags" {
    type = map(string)
    default = {}
}

variable "vpc_id" {
    type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "namespace" {
    type = string
}

variable "instance_type" {
  type = string
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "enable_ec2" {
  type = bool
  default = false
}

variable "enable_fargate" {
  type = bool
  default = true
}

variable "ecs_instance_sg_ids" {
  type = list(string)
}