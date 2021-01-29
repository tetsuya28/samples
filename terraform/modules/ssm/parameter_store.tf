resource "aws_ssm_parameter" "this" {
    for_each = var.parameters
  name        = "/${var.app}/${each.key}"
  description = ""
  type        = "SecureString"
  value       = each.value
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
