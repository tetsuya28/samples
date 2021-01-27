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
  execution_role_arn       = aws_iam_role.task_exec.arn
  requires_compatibilities = ["EC2"]
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_ecs_service" "this" {
  name            = var.app
  cluster         = var.app
  task_definition = "${aws_ecs_task_definition.this.family}:${max(data.aws_ecs_task_definition.this.revision, aws_ecs_task_definition.this.revision)}"
  desired_count   = var.service_desired_count
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
