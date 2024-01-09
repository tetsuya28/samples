output "rds_master_password" {
  value = aws_ssm_parameter.this.name
}
