variable "name" {
  type = string
}

variable "common_tags" {
  type = map(list())
  default = {}
}

variable "region" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "log_groups" {
  type = map(object({
    retention = number
  }))
}

variable "alarms" {
  description = "CloudWatch CPU or Memory alarms"
  type = map(object({
    metric_name = string
    namespace = string
    comparison_operator = string
    threshold = number
    period = number
    evaluation_periods = number
    statistic = string 
  }))
  default = {}
}