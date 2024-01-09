output "elastic_ip" {
  value = aws_eip.this[0].public_ip
}
