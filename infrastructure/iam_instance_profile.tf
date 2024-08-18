
# resource "aws_iam_instance_profile" "github_runner_instance_profile" {
#   name = "github_runner_ec2_instance_profile-${var.infra_env}"
#   role = aws_iam_role.github_runner_role[0].name

#   tags = {
#   }
# }