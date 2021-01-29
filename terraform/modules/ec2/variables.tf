variable "app" {
  description = "Application name"
}
variable "env" {}
variable "created_by" {
  description = "tag description for resources made by terraform"
}
variable "ami_id" {}
variable "public_ip" {
  default = true
}
variable "elastic_ip" {
  default = true
}
variable "subnet_id" {}
variable "iam_profile" {
  default = ""
}
variable "key_name" {}
variable "security_group_ids" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "user_data" {}
