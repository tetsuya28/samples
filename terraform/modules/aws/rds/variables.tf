variable "app" {
  description = "Application name"
}
variable "created_by" {
  description = "tag description for resources made by terraform"
}

variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "source_sg_ids" {
  type = list(string)
}

variable "engine" {}
variable "engine_version" {}
variable "family" {}
variable "instance_type" {
  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
  default = "db.t3.small"
}
variable "instance_count" {
  default = 1
}
variable "database_name" {}
variable "master_username" {}

variable "rds_params" {
  type = map(string)
}
