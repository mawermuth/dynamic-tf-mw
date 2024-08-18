
variable "namespace" {
  type        = string
  description = "The prefix to resource names"
}

variable "s3_bucket_name" {
  type        = string
  default     = "tfstate-bucket"
  description = "name of the s3 bucket the tfstate will be stored"
  validation {
    condition     = length(var.s3_bucket_name) > 5
    error_message = "Required, must have a sensible value"
  }
}

variable "dynamo_db_table_name" {
  type        = string
  default     = "aws-locks"
  description = "The name of the dynamo_db_table tf locks will be stored"
  validation {
    condition     = length(var.dynamo_db_table_name) > 5
    error_message = "Required, must have a sensible value"
  }
}

variable "tags" {
  nullable = false
  type     = map(any)
  default = {
    Terraform = "true",
    BuiltBy   = "module"
  }
  description = "The tags which will be added to the aws resources"
}