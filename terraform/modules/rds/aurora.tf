data "aws_availability_zones" "this" {}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.app}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_type
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.app
  availability_zones              = data.aws_availability_zones.this.names
  engine                          = var.engine
  engine_version                  = var.engine_version
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = random_password.this.result
  db_subnet_group_name            = aws_db_subnet_group.this.id
  vpc_security_group_ids          = [aws_security_group.this.id]
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}
