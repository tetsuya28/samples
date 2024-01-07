resource "aws_ssm_parameter" "this" {
  name        = "/${var.app}/rds/password"
  description = "RDS master password"
  type        = "SecureString"
  value       = random_password.this.result
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!*-_=+"
}
