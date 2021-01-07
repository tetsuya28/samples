resource "aws_cloudwatch_log_group" "this" {
  name = var.name
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
