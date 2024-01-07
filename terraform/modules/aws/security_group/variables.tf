variable "env" {}
variable "name" {
  description = "Name of security group"
}
variable "created_by" {
  description = "tag description for resources made by terraform"
}
variable "vpc_id" {}
variable "cidr_ingress_rules" {
  type = map(string)
}
