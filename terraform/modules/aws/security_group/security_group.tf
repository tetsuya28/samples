resource "aws_security_group" "this" {
  name        = var.name
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = var.name
    Env       = var.env
    CreatedBy = var.created_by
  }
}

resource "aws_security_group_rule" "this" {
  for_each          = var.cidr_ingress_rules
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = [each.key]
  security_group_id = aws_security_group.this.id
}
