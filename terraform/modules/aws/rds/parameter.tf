resource "aws_rds_cluster_parameter_group" "this" {
  name   = var.app
  family = var.family

  dynamic "parameter" {
    for_each = var.rds_params
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}
