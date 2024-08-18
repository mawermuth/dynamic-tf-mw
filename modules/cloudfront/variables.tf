variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "default_ttl" {
  description = "default ttl"
  default     = 30
  type        = number
}

variable "max_ttl" {
  description = "default max_tll"
  default     = 300
  type        = number
}

variable "min_ttl" {
  description = "default min_tll"
  default     = 1
  type        = number
}

variable "default_behavior_min_tll" {
  description = "default cache behavior min_tll"
  default     = 0
  type        = number
}

variable "default_behavior_default_ttl" {
  description = "default cache behavior min_tll"
  default     = 3600
  type        = number
}

variable "default_behavior_max_ttl" {
  description = "default cache behavior min_tll"
  default     = 86400
  type        = number
}

variable "ordered_behavior_min_tll" {
  description = "ordered cache behavior min_tll"
  default     = 0
  type        = number
}

variable "ordered_behavior_default_ttl" {
  description = "ordered cache behavior min_tll"
  default     = 86400
  type        = number
}

variable "ordered_behavior_max_ttl" {
  description = "ordered cache behavior min_tll"
  default     = 31536000
  type        = number
}

variable "cloudfront_default_certificate" {
  description = "cloudfront viewer certificate boolean"
  default     = true
  type        = bool
}

variable "alternate_domain_names" {
  description = "cloudfront alternate domain names for certificate."
  type        = string
}

/////////////
variable "bucket_name" {
  description = "Front-end S3 Bucket name."
  type        = string
}

variable "bucket_versioning" {
  description = "Front-end S3 Bucket Versioning."
  default     = "Enabled"
  type        = string
}

variable "bucket_ownership" {
  description = "Bucket ownership prefered."
  type        = string
}

variable "cloudfront_origin_name" {
  description = "Cloud Front origin access control name."
  type        = string
}

variable "cloudfront_origin_description" {
  description = "Cloud Front origin access control description."
  type        = string
}

variable "cloudfront_origin_type" {
  description = "Cloud Front origin access control origin type."
  type        = string
}

variable "cloudfront_origin_behavior" {
  description = "Cloud Front origin access control signing behavior."
  type        = string
}

variable "cloudfront_origin_protocol" {
  description = "Cloud Front origin access control signing protocol."
  type        = string
}

variable "cloudfront_default_object" {
  description = "Cloud Front object with default cache behavior data."
  type        = string
}

variable "cloudfront_enabled" {
  description = "Cloud Front bool to enable to accept end user requests for content."
  type        = bool
}

variable "cloudfront_ipv6_enabled" {
  description = "Cloud Front bool to enable ipv6 for the distribution."
  type        = bool
}

variable "cloudfront_function" {
  description = "Cloud Front object for FE function."
  type = object({
    name    = string
    comment = string
    publish = bool
  })
}

variable "cloudfront_default_cache_behavior" {
  description = "Cloud Front object with default cache behavior data."
  type = object({
    allowed_methods = list(string)
    cached_methods  = list(string)
    cookies_forward = string
    protocol_policy = string
  })
}

variable "cloudfront_ordered_cache_behavior" {
  description = "Cloud Front object with ordered cache behavior data."
  type = object({
    allowed_methods = list(string)
    cached_methods  = list(string)
    cookies_forward = string
    protocol_policy = string
  })
}

variable "cloudfront_restriction_type" {
  description = "Cloud Front restriction(geo restriction) type"
  type        = string
}

variable "cloudfront_certificate_arn" {
  description = "Cloud Front HTTPS certificate"
  type        = string
}

# waf
variable "ipv4address" {
  type    = list(any)
  default = []
}

variable "cloudfront_origin_request_policy" {
  description = "Cloud Front origin request policy for cache behavior"
  type = object({
    comment               = string
    name                  = string
    cookie_behavior       = string
    header_behavior       = string
    headers_items         = list(string)
    query_string_behavior = string
  })
}

variable "cloudfront_cache_policy" {
  description = "Cloud Front cache policy for cache behavior"
  type = object({
    comment                       = string
    name                          = string
    enable_accept_encoding_brotli = bool
    enable_accept_encoding_gzip   = bool
    cookie_behavior               = string
    header_behavior               = string
    query_string_behavior         = string
  })
}