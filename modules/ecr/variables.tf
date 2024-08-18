variable "ecr_name" {
  description = "The name of the ECR registry"
  type        = string
  default     = null
}

variable "image_mutability" {
  description = "The mutability of the image"
  type        = string
  default     = "IMMUTABLE"
}

variable "encrypt_type" {
  description = "The encryption type of the image"
  type        = string
  default     = "KMS"
}