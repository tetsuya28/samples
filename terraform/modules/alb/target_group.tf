resource "aws_lb_target_group" "this" {
  name                 = var.app
  port                 = var.target_group_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/healthz"
  }
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
