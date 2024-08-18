###################################
# S3
###################################
resource "aws_s3_bucket" "generic_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

###################################
# S3 Bucket Policy
###################################
resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  # count = var.bucket_policy != null ? 1 : 0

  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]

  bucket = aws_s3_bucket.generic_bucket.id
  policy = var.bucket_policy
}

###################################
# S3 Bucket Public Access Block
###################################
resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  depends_on = [aws_s3_bucket.generic_bucket]

  bucket = aws_s3_bucket.generic_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  # set to false to allow public access to bucket on 1st run
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "website" {
  count = var.bucket_website == true ? 1 : 0

  bucket = aws_s3_bucket.generic_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors_config" {
  depends_on = [aws_s3_bucket.generic_bucket]
  count      = var.bucket_cors == true ? 1 : 0

  bucket = aws_s3_bucket.generic_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 0
  }
}

resource "aws_s3_bucket_ownership_controls" "fe_ownership" {
  count = var.bucket_ownership == null ? 0 : 1

  bucket = aws_s3_bucket.generic_bucket.id
  rule {
    object_ownership = var.bucket_ownership
  }
  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
}

resource "aws_s3_bucket_acl" "private_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.fe_ownership,
    aws_s3_bucket_public_access_block.bucket_access_block,
  ]

  bucket = aws_s3_bucket.generic_bucket.id
  acl    = "private"
}

# resource "aws_s3_bucket_versioning" "versioning_enabling" {
#   bucket = aws_s3_bucket.generic_bucket.id
#   versioning_configuration {
#     status = var.bucket_versioning
#   }
# }