data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
}

resource "aws_ecs_task_definition" "this" {
  family                = var.name
  container_definitions = var.container_def
  task_role_arn = aws_iam_role.task.arn
  task_execution_role_arn = aws_iam_role.task_exec.arn
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.ecs_cluster_name
  task_definition = "${aws_ecs_task_definition.this.family}:${max("${data.aws_ecs_task_definition.this.revision}", "${aws_ecs_task_definition.this.revision}")}"
  desired_count   = var.ecs_service_desired_count
}

resource "aws_cloudwatch_log_group" "this" {
  name = var.cloudwatch_log_group_name
}
