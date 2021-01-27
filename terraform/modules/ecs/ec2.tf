data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_configuration" "this" {
  name                        = "${var.app}-ecs"
  image_id                    = data.aws_ssm_parameter.ami_id.value
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.this.id]
  enable_monitoring           = true
  iam_instance_profile        = aws_iam_instance_profile.this.name
  user_data                   = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.app} >> /etc/ecs/ecs.config;
EOF
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "this" {
  name                 = "${var.app}-ecs"
  min_size             = var.instance_min_size
  max_size             = var.instance_max_size
  desired_capacity     = var.instance_desired_count
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnet_ids
  tags = [
    {
      key                 = "AmazonECSManaged"
      value               = true
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.app}ECSInstance"
      propagate_at_launch = true
    },
    {
      key                 = "CreatedBy"
      value               = var.created_by
      propagate_at_launch = true
    }
  ]
}

# IAM
data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy" "ecr" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "ecs" {
  source_json = data.aws_iam_policy.this.policy
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.app}InstanceProfile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "${var.app}ECSInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name   = "${var.app}EC2ForECSPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ecr.arn
}
