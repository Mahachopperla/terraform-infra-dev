resource "aws_cloudfront_distribution" "roboshop" {
  origin {
    domain_name = "dev.${var.hosted_zone_name}" # Replace with your ALB's DNS name
    origin_id   = "dev.${var.hosted_zone_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # or "http-only", "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true

  aliases = ["cdn.${var.hosted_zone_name}"] # give ur cdn domain name 

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "dev.${var.hosted_zone_name}"

    cache_policy_id  = local.caching_disable

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "dev.${var.hosted_zone_name}"
    cache_policy_id  = local.caching_enable

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }

  tags = merge(
    local.common_Tags,{
        Name = "${var.project}-${var.environment}"
    }
  )

  viewer_certificate {
    acm_certificate_arn = local.certificate_arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "frontend_alb" {
  zone_id = var.hosted_zone_id
  name    = "cdn.${var.hosted_zone_name}" #dev.daws84s.site
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = true
  }
}