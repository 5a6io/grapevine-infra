variable "region"       { type = string }
variable "name"         { type = string }
variable "common_tags" {
  type = map(string)
  default = {}
}

# Network
variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}
variable "availability_zones" {
  description = "가용 영역 리스트 (하나 또는 여러 개)"
  type        = list(string)
}
variable "public_subnets_cidr" {
  description = "퍼블릭 서브넷 CIDR 리스트"
  type        = list(string)
}
variable "private_subnets_cidr" {
  description = "프라이빗 서브넷 CIDR 리스트"
  type        = list(string)
}
variable "multi_nat" {
  description = "AZ 별 NAT Gateway 여부"
  type        = bool
  default     = false
}

# Database
# rds instance
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "rds_backup_day" { type = number }

# rds proxy
variable "proxy_idle_client_timeout" { type = number }
variable "proxy_role_arn" { type = string }
variable "rds_proxy_secret_arn" { type = string }
variable "proxy_borrow_timeout" { type = number }

#ecs
variable "service_definitions" {
  type = map(object({
    port = number
    ingress_from = string
    egress = list(object({
      to = string
      port = number
    }))
    cpu = string
    memory = string
    image = string
    env_map = map(string)
  }))
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

#alb
variable "health_check_path" {
  type = string
}

variable "services" {
  type = map(object({
    port = number
    paths = list(string) 
  }))
}