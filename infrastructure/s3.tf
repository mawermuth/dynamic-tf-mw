module "s3" {
  source = "../modules/s3"

  for_each = {
    for s3_bucket in var.s3_data : s3_bucket.name => s3_bucket
  }

  bucket_name       = "${each.value.name}-${var.infra_env}"
  bucket_versioning = each.value.versioning
  bucket_ownership  = each.value.ownership
  bucket_website    = each.value.website
  bucket_cors       = each.value.cors
  bucket_policy     = jsonencode(each.value.policy)
}
