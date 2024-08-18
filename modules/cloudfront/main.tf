module "s3-bucket" {
  source = "../s3"

  bucket_name       = "${var.bucket_name}-${var.infra_env}"
  bucket_versioning = var.bucket_versioning
  bucket_ownership  = var.bucket_ownership
  bucket_website    = true
  bucket_cors       = true
  bucket_policy     = data.aws_iam_policy_document.fe_bucket_policy.json
}

###################################
# IAM Policy Document
###################################
data "aws_iam_policy_document" "fe_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [module.s3-bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      module.s3-bucket.arn,
      "${module.s3-bucket.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::341654622034:user/tf-full-access"]
    }
  }
}

###################################
# CloudFront Origin Access Identity
###################################
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "dynamic-tf"
}

###################################
# CloudFront Function
###################################
resource "aws_cloudfront_function" "fe_routing" {
  name    = "${var.cloudfront_function.name}-${var.infra_env}"
  runtime = "cloudfront-js-1.0"
  comment = var.cloudfront_function.comment
  publish = var.cloudfront_function.publish
  code    = file("${path.module}/functions/fe-routing.js")
}

resource "aws_cloudfront_origin_access_control" "fe_s3_origin" {
  name                              = "${var.cloudfront_origin_name}-${var.infra_env}"
  description                       = var.cloudfront_origin_description
  origin_access_control_origin_type = var.cloudfront_origin_type
  signing_behavior                  = var.cloudfront_origin_behavior
  signing_protocol                  = var.cloudfront_origin_protocol
}

###################################
# CloudFront
###################################
resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [module.logs-s3-bucket, module.s3-bucket]

  aliases             = var.alternate_domain_names != "" ? [var.alternate_domain_names] : []
  enabled             = true
  default_root_object = "index.html"
  # aliases             = [aws_s3_bucket.this.bucket]
  web_acl_id      = aws_wafv2_web_acl.WafV2CloudfrontWebAcl.arn
  is_ipv6_enabled = false

  logging_config {
    include_cookies = true
    bucket          = "${module.logs-s3-bucket.bucket}.s3.amazonaws.com"
    prefix          = "CloudFront"
  }

  lifecycle {
    prevent_destroy = false
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = module.s3-bucket.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 2 * 60
    max_ttl     = 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.fe_routing.arn
    }
  }

  origin {
    domain_name = module.s3-bucket.bucket_regional_domain_name
    origin_id   = module.s3-bucket.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = var.cloudfront_certificate_arn
    ssl_support_method  = "sni-only"
  }

}

resource "aws_cloudfront_origin_request_policy" "policy" {
  comment = var.cloudfront_origin_request_policy.comment
  name    = "${var.cloudfront_origin_request_policy.name}-${var.infra_env}"

  cookies_config {
    cookie_behavior = var.cloudfront_origin_request_policy.cookie_behavior
  }

  headers_config {
    header_behavior = var.cloudfront_origin_request_policy.header_behavior

    headers {
      items = var.cloudfront_origin_request_policy.headers_items
    }
  }

  query_strings_config {
    query_string_behavior = var.cloudfront_origin_request_policy.query_string_behavior
  }
}

resource "aws_cloudfront_cache_policy" "policy" {
  comment     = var.cloudfront_cache_policy.comment
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl
  name        = "${var.cloudfront_cache_policy.name}-${var.infra_env}"

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = var.cloudfront_cache_policy.enable_accept_encoding_brotli
    enable_accept_encoding_gzip   = var.cloudfront_cache_policy.enable_accept_encoding_gzip

    cookies_config {
      cookie_behavior = var.cloudfront_cache_policy.cookie_behavior
    }

    headers_config {
      header_behavior = var.cloudfront_cache_policy.header_behavior
    }

    query_strings_config {
      query_string_behavior = var.cloudfront_cache_policy.query_string_behavior
    }
  }
}