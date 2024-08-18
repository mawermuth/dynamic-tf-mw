data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# data "aws_secretsmanager_secret" "rds" {
#   name = "rds-tf-secret-${var.infra_env}"
# }