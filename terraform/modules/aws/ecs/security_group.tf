resource "aws_security_group" "this" {
  name   = "${var.app}-ec2"
  vpc_id = var.vpc_id
  ingress {
    description     = "HTTP"
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "${var.app}-ec2"
    CreatedBy = var.created_by
  }
}
