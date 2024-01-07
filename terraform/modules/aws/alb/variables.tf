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
# https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/load-balancer-access-logs.html
variable "elb_account_id" {
  description = "Account ID for ELB managed by AWS"
  default     = "582318560864"
}

variable "target_group_port" {}
