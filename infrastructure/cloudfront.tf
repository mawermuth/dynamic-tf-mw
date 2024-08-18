locals {
  cloudfront_aws_s3_bucket = module.cloudfront.cloudfront_aws_s3_bucket
  cloudfront_domain_name   = module.cloudfront.cloudfront_domain_name
  pr_cloudfront_vpn_ips = [
    "0.0.0.0/22",
  ]
}

module "cloudfront" {
  source = "../modules/cloudfront"

  infra_env = var.infra_env

  bucket_name      = var.cloudfront_data.fe_bucket_name
  bucket_ownership = var.cloudfront_data.bucket_ownership

  cloudfront_origin_name        = var.cloudfront_data.origin_name
  cloudfront_origin_description = var.cloudfront_data.origin_description
  cloudfront_origin_type        = var.cloudfront_data.origin_type
  cloudfront_origin_behavior    = var.cloudfront_data.origin_behavior
  cloudfront_origin_protocol    = var.cloudfront_data.origin_protocol
  cloudfront_function           = var.cloudfront_data.function
  cloudfront_certificate_arn    = var.cloudfront_data.certificate_arn
  alternate_domain_names        = var.cloudfront_data.alternate_domain_names

  cloudfront_default_object         = var.cloudfront_data.default_object
  cloudfront_enabled                = var.cloudfront_data.enabled
  cloudfront_ipv6_enabled           = var.cloudfront_data.ipv6_enabled
  cloudfront_default_cache_behavior = var.cloudfront_data.default_cache_behavior
  cloudfront_ordered_cache_behavior = var.cloudfront_data.ordered_cache_behavior
  cloudfront_restriction_type       = var.cloudfront_data.restriction_type
  cloudfront_origin_request_policy  = var.cloudfront_data.origin_request_policy
  cloudfront_cache_policy           = var.cloudfront_data.cache_policy
  ipv4address                       = can(regex("pr[1-9]+", var.infra_env)) ? local.pr_cloudfront_vpn_ips : null
}