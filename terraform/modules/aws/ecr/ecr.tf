resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.is_mutable ? "MUTABLE" : "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

