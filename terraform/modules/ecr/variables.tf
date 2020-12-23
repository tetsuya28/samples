variable "app" {
  description = "Application name"
}

variable "created_by" {
  description = "tag description for resources made by terraform"
}

variable "name" {
  description = "Name of Repository"
}

variable "is_mutable" {
  description = "Whether a repository is mutable or not"
  default     = true
}
