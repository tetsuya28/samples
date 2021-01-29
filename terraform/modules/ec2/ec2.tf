resource "aws_instance" "this" {
  ami                         = var.ami_id
  associate_public_ip_address = var.public_ip
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.iam_profile
  key_name                    = var.key_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_group_ids
  user_data                   = var.user_data
  tags = {
    Name      = "${var.app}-${var.env}"
    Env       = var.env
    CreatedBy = var.created_by
  }
}

resource "aws_eip" "this" {
  count    = var.elastic_ip ? 1 : 0
  instance = aws_instance.this.id
  vpc      = true
}
