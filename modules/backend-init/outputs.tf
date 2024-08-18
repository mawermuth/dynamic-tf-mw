
output "s3_bucket_name" {
  value       = local.s3_bucket_name
  description = "name of the s3 bucket the tfstate will be stored"
}

output "s3_bucket_arn" {
  value       = local.s3_bucket_arn
  description = "name of the s3 bucket the tfstate will be stored"
}

output "dynamo_db_table_name" {
  value       = local.dynamo_db_table_name
  description = "The name of the dynamo_db_table tf locks will be stored"
}

output "dynamo_db_table_arn" {
  value       = local.dynamo_db_table_arn
  description = "The arn of the dynamo_db_table tf locks will be stored"
}