output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.rds_instance.endpoint
}

output "db_instance_arn" {
  description = "The ARN of the database instance"
  value       = aws_db_instance.rds_instance.arn
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.my_rds_instance_secret.arn
}
