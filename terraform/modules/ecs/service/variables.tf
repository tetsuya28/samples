variable "name" {}
variable "container_def" {}
variable "ecs_cluster_name" {}
variable "ecs_service_desired_count" {
  type    = number
  default = 1
}
variable "cloudwatch_log_group_name" {}
variable "task_role_policy" {}
variable "task_exec_role_policy" {}
