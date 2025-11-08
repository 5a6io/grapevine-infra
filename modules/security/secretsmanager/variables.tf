variable "name" { type = string }
variable "common_tags" {
  type = map(string)
  default = {}
}

variable "db_username" { type = string }
variable "db_password" { type = string }