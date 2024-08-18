output "cloudfront_aws_s3_bucket" {
  value = module.s3-bucket.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}