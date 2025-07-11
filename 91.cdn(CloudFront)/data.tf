data "aws_cloudfront_cache_policy" "cache_enable" {
  name = "Managed-CachingOptimized"  # Replace with the actual name of your cache policy . u can get it from aws portal
}

data "aws_cloudfront_cache_policy" "cache_disable" {
  name = "Managed-CachingDisabled"  # Replace with the actual name of your cache policy
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project}/${var.environment}/certificate_arn"
}