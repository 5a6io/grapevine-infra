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

variable "target_type" {
  type = string
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

variable "health_check_path" {
  type = string
  default = "/health"
}

variable "subnet_ids" {
  type = list(string)
}

variable "sg_alb_id" {
  type = string
}

# variable "alb_certificate_arn" {
#   type = string
# }