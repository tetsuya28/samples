output "zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "acm_arn" {
  value = aws_acm_certificate.this.arn
}
