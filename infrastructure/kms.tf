# resource "aws_kms_key" "github_runner_key" {
#   description              = "KMS key for encrypting github runner EC2 instance volumes"
#   deletion_window_in_days  = 10
#   customer_master_key_spec = "SYMMETRIC_DEFAULT"
#   is_enabled               = true
#   enable_key_rotation      = false

#   tags = {
#   }
# }

# resource "aws_kms_grant" "github_runner_key_grant" {
#   key_id            = aws_kms_key.github_runner_key[0].key_id
#   name              = "github_runner_ec2_grant-${var.infra_env}"
#   grantee_principal = aws_iam_role.github_runner_role[0].arn
#   operations        = ["Encrypt", "Decrypt", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext"]
# }