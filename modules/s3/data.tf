data "aws_caller_identity" "current" {}
# data "aws_iam_policy_document" "managed_role" {
#   count = (var.bucket_policy != null) ? 1 : 0

#   statement {
#     principals {
#       type = var.bucket_policy.statement.principals.type
#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dynamictf-iam-role"
#       ]
#     }

#     actions = var.bucket_policy.statement.principals.actions

#     resources = [
#       aws_s3_bucket.generic_bucket.arn,
#       "${aws_s3_bucket.generic_bucket.arn}/*",
#     ]
#   }
# }
