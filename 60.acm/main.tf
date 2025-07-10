#creating certificate using certificate manager

resource "aws_acm_certificate" "robotshop_certificate" {
  domain_name       = "*.robotshop.site"
  validation_method = "DNS"

  tags = merge(local.common_Tags, 
  {
    Name = "${var.project}-${var.environment}-certificate"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# creating txt records for domain validation

resource "aws_route53_record" "certificate_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.robotshop_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

# once records are created to validate then we need to click on validate

resource "aws_acm_certificate_validation" "robotshop_certificate_validation" {
  certificate_arn         = aws_acm_certificate.robotshop_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_records : record.fqdn]
}