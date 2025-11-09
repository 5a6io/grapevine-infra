variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {}
}


variable "alb_arn" {
  type = string
}

variable "waf_log_group_arn" {
  type = list(string)
}