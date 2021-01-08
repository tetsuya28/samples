# Task role
resource "aws_iam_role_policy" "task" {
  count  = var.task_role_policy == "" ? 0 : 1
  name   = "${var.app}ECSTask"
  role   = aws_iam_role.task.id
  policy = var.task_role_policy
}

resource "aws_iam_role" "task" {
  name               = "${var.app}ECSTask"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_iam_role_policy_attachment" "task" {
  count      = var.task_role_policy == "" ? 0 : 1
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_role_policy.task[count.index].id
}

# Task exec role
resource "aws_iam_role_policy" "task_exec" {
  name = "${var.app}ECSTaskExec"
  role = aws_iam_role.task_exec.id
  # TODO: Specify Resource
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "kms:Decrypt",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_role" "task_exec" {
  name               = "${var.app}ECSTaskExec"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
