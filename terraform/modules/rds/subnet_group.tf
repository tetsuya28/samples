resource "aws_db_subnet_group" "this" {
  name       = var.app
  subnet_ids = var.subnet_ids

  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
