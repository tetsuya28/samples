data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  # Avoid error for the first time
  # https://github.com/hashicorp/terraform-provider-aws/issues/1274#issuecomment-378712913
  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.app
  container_definitions    = var.container_def
  task_role_arn            = aws_iam_role.task.arn
  requires_compatibilities = ["EC2"]
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_ecs_service" "this" {
  name            = var.app
  cluster         = var.app
  task_definition = "${aws_ecs_task_definition.this.family}:${max("${data.aws_ecs_task_definition.this.revision}", "${aws_ecs_task_definition.this.revision}")}"
  desired_count   = var.service_desired_count
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.app}/ecs"
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}