variable "name" {
  type = string
}

variable "repositories" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}