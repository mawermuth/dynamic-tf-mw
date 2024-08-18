module "logs-s3-bucket" {
  source = "../s3"

  bucket_name       = "logs-cloudfront-${var.infra_env}"
  bucket_versioning = "Disabled"
  bucket_ownership  = var.bucket_ownership
  bucket_website    = false
  bucket_cors       = false
  bucket_policy     = data.aws_iam_policy_document.logs_bucket_policy.json
}

###################################
# IAM Policy Document
###################################
data "aws_iam_policy_document" "logs_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.logs-s3-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [module.logs-s3-bucket.arn]

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
      module.logs-s3-bucket.arn,
      "${module.logs-s3-bucket.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::341654622034:user/tf-full-access"]
    }
  }
}

resource "aws_cloudfront_realtime_log_config" "cloudfront_log_config" {
  name          = "cloudfront-realtime-logging-${var.infra_env}"
  sampling_rate = 75
  fields        = ["timestamp", "c-ip"]

  endpoint {
    stream_type = "Kinesis"

    kinesis_stream_config {
      role_arn   = aws_iam_role.realtime_log_role.arn
      stream_arn = aws_kinesis_stream.cloudfront_stream.arn
    }
  }

  depends_on = [aws_iam_role_policy.realtime_log]
}

resource "aws_kinesis_stream" "cloudfront_stream" {
  name             = "cloudfront-kinesis-${var.infra_env}"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "realtime_log_role" {
  name               = "cloudfront-realtime-log-config-${var.infra_env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "realtime_log_policy" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStreamSummary",
      "kinesis:DescribeStream",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
    ]

    resources = [aws_kinesis_stream.cloudfront_stream.arn]
  }
}

resource "aws_iam_role_policy" "realtime_log" {
  name   = "cloudfront-realtime-log-config-${var.infra_env}"
  role   = aws_iam_role.realtime_log_role.id
  policy = data.aws_iam_policy_document.realtime_log_policy.json
}
