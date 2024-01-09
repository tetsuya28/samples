resource "aws_route53_zone" "this" {
  name = var.domain
  tags = {
    Name      = "${var.app}-${var.env}"
    Env       = var.env
    CreatedBy = var.created_by
  }
}
