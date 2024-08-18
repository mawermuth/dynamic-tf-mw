##
# Module to build the DevOps "seed" configuration
##
locals {
  s3_bucket_name       = "${var.namespace}-${var.s3_bucket_name}"
  dynamo_db_table_name = "${var.namespace}-${var.dynamo_db_table_name}"
}

# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = local.s3_bucket_name

  # Prevents Terraform from destroying or replacing this object - a great safety mechanism
  lifecycle {
    prevent_destroy = false #todo
  }

  tags = var.tags
}

resource "aws_kms_key" "state_bucket_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    #status = "Enabled"
    status = "Disabled"
  }
}

# Build a DynamoDB to use for terraform state locking
resource "aws_dynamodb_table" "tf_lock_state" {
  name = local.dynamo_db_table_name

  # Pay per request is cheaper for low-i/o applications, like our TF lock state
  billing_mode = "PAY_PER_REQUEST"

  # Hash key is required, and must be an attribute
  hash_key = "LockID"

  # Attribute LockID is required for TF to use this table for lock state
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}

locals {
  s3_bucket_arn       = aws_s3_bucket.state_bucket.arn
  dynamo_db_table_arn = aws_dynamodb_table.tf_lock_state.arn
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}