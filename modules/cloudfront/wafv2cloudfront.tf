resource "aws_wafv2_web_acl" "WafV2CloudfrontWebAcl" {
  name        = "Cloudflare_Cloudfront_WebAcl-${var.infra_env}"
  description = "Permits only Cloudflare IPs"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Cloudfalre_WebAcl_Metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "Cloudflare_IPv4_Rule"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.IPv4CloudfrontCloudflareIPSet.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Cloudflare_IPv4_Rule_Metric"
      sampled_requests_enabled   = true
    }
  }

}

# resource "aws_wafv2_web_acl_logging_configuration" "WafV2WebAclCloudfrontLogging" {
#     log_destination_configs = [aws_kinesis_firehose_delivery_stream.KinesisFirehoseDeliveryStream.arn]
#     resource_arn = aws_wafv2_web_acl.WafV2CloudfrontWebAcl.arn
# }