variable "name" {
  type = string
}

variable "common_tags" {
  type = map(string)
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

variable "cloudwatch_ecs_log_group" {
  type = list(string)
}

# variable "alarms" {
#   description = "CloudWatch CPU or Memory alarms"
#   type = map(object({
#     metric_name = string
#     namespace = string
#     comparison_operator = string
#     threshold = number
#     period = number
#     evaluation_periods = number
#     statistic = string 
#   }))
#   default = {}
# }