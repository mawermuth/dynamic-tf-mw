locals {
  defaults = [
    "0.0.0.0/20"
  ]
  addresses = coalesce(var.ipv4address, local.defaults)
}

resource "aws_wafv2_ip_set" "IPv4CloudfrontCloudflareIPSet" {
  name               = "IPv4CloudfrontCloudflareIPSet-${var.infra_env}"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = local.addresses
}