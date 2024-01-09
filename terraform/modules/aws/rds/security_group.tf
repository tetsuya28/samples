resource "aws_security_group" "this" {
  name   = "${var.app}-rds"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "${var.app}-rds"
    CreatedBy = var.created_by
  }
}

resource "aws_security_group_rule" "this" {
  count                    = length(var.source_sg_ids)
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.source_sg_ids[count.index]
}
