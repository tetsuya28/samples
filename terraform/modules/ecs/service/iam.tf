# Task role
resource "aws_iam_role_policy" "task" {
  name = "${var.name}_task_role_policy"
  role = aws_iam_role.task.id
  policy =var.task_role_policy
}

resource "aws_iam_role" "task" {
  name = "${var.name}_task_role"

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
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task.arn
}

# Task execution role
resource "aws_iam_role_policy" "task_exec" {
  name = "${var.name}_task_exec_role_policy"
  role = aws_iam_role.task_exec.id
  policy =var.task_exec_role_policy
}

resource "aws_iam_role" "task_exec" {
  name = "${var.name}_task_exec_role"

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
}

resource "aws_iam_role_policy_attachment" "task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = aws_iam_policy.task_exec.arn
}