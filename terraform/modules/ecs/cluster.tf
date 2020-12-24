resource "aws_ecs_cluster" "this" {
  name = var.app
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
