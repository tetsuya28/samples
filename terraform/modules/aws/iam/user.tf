resource "aws_iam_user" "this" {
  name = var.name
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_iam_user_policy" "this" {
  name   = "${var.name}IAMUser"
  user   = aws_iam_user.this.name
  policy = var.policy
}
