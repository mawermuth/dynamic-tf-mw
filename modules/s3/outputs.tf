output "arn" {
  value = aws_s3_bucket.generic_bucket.arn
}

output "bucket" {
  value = aws_s3_bucket.generic_bucket.bucket
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.generic_bucket.bucket_regional_domain_name
}

output "id" {
  value = aws_s3_bucket.generic_bucket.id
}