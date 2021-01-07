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
  cluster_identifier     = var.app
  availability_zones     = data.aws_availability_zones.this.names
  engine                 = var.engine
  engine_version         = var.engine_version
  database_name          = var.database_name
  master_username        = var.master_username
  master_password        = var.master_password
  db_subnet_group_name   = aws_db_subnet_group.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_security_group" "this" {
  name   = "${var.app}-rds"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "${var.app}-rds"
    CreatedBy = var.created_by
  }
}

resource "aws_security_group_rule" "this" {
  count                    = length(var.source_sg_ids)
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.source_sg_ids[count.index]
}
