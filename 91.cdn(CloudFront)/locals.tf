locals {
  caching_enable = data.aws_cloudfront_cache_policy.cache_enable.id
  caching_disable = data.aws_cloudfront_cache_policy.cache_disable.id
  certificate_arn = data.aws_ssm_parameter.certificate_arn.value

 common_Tags ={
    project = var.project
    environment = var.environment
    terraform = true
 }
}