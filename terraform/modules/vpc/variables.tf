variable "app" {
  description = "Application name"
}

variable "created_by" {
  description = "tag description for resources made by terraform"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet_count" {
  type = number
}

variable "nat" {
  description = "whether need a nat or not"
  type        = bool
}
