variable "name" { type = string }
variable "common_tags" {
  type = map(string)
  default = {}
}

# rds subnet
variable "private_subnet_ids" {type = list(string)}

# rds instance
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_name" {
  type    = string
  default = ""
}
variable "engine_version" {
  type    = string
  default = "8.0"
}
variable "instance_class" {
  type    = string
  default = "db.m5.large"
}
variable "rds_backup_day" { type = number }
variable "sg_rds_id" {type = string}

# rds proxy
variable "proxy_idle_client_timeout" { 
  type = number 
  default = 1800
}
variable "rds_proxy_role" { type = string }
variable "rds_proxy_secret_arn" { type = string }
variable "proxy_borrow_timeout" { 
  type = number 
  default = 120
}
variable "sg_rds_proxy_id" {type = string}