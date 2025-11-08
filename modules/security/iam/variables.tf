variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
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