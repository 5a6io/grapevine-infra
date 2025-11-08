variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "private_key" {
  type = string
}

variable "certificate_body" {
  type = string
}