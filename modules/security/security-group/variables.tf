variable "name" { type = string }
variable "common_tags" {
  type = map(string)
  default = {}
}

variable "vpc_id" { type = string }

# variable "instances" {
#   type = map(string)
# }