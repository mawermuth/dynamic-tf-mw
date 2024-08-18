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

variable "bucket_website" {
  description = "Bucket website enabled."
  type        = bool
}

variable "bucket_cors" {
  description = "Bucket CORS Configuration enabled."
  type        = bool
}

variable "bucket_policy" {
  description = "Bucket Policy Data enabled."
  default     = null
  type        = any
}
