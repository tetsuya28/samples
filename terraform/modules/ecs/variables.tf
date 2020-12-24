variable "app" {
  description = "Application name"
}
variable "created_by" {
  description = "tag description for resources made by terraform"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_min_size" {
  type    = number
  default = 1
}
variable "instance_max_size" {
  type    = number
  default = 1
}
variable "instance_desired_count" {
  type    = number
  default = 1
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "container_def" {}
variable "service_desired_count" {
  type    = number
  default = 1
}
variable "task_role_policy" {}
variable "task_exec_role_policy" {}
