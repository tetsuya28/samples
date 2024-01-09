variable "app" {
  description = "Application name"
}
variable "created_by" {
  description = "tag description for resources made by terraform"
}
variable "vpc_id" {}
variable "alb_sg_id" {}
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
variable "container_def" {}
variable "service_desired_count" {
  type    = number
  default = 1
}
variable "task_role_policy" {}

variable "container_name" {
  description = "Name of container to attache alb"
}

variable "container_port" {
  description = "Port of container to attache alb"
}

variable "target_group_arn" {
  description = "ARN of target_group to attache container"
}
