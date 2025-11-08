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

#ecr
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
    }))
}

variable "namespace" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "environment" {
  type = list(string)
  default = [  ]
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "enable_ec2" {
  type = bool
  default = false
}

variable "enable_fargate" {
  type = bool
  default = true
}

#alb
variable "health_check_path" {
  type = string
}

variable "alb_certificate_arn" {
  type = string
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

#acm
# variable "private_key" {
#   type = string
# }

# variable "certificate_body" {
#   type = string
# }