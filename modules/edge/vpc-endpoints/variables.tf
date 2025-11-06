variable "name" { type = string }
variable "common_tags" {
  type = map(string)
  default = {}
}

variable "region"  { type = string }
variable "vpc_id"     { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "private_route_table_ids" { type = list(string) }
variable "sg_vpce_id" { type = string }