variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}

variable "repositories" {
  type = list(string)
}

variable "keep_tag_prefixes" {
  type = list(string)
  default = [ "latest" ]
}

variable "keep_any_last" {
  type = number
  default = 10
}

variable "mutability" {
  type = string
  default = "MUTABLE"
}