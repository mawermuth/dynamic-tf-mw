resource "aws_iam_role" "github_runner_role" {
  name = "github_runner_ec2_role-${var.infra_env}"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
  }
}

# resource "aws_iam_role_policy_attachment" "github_runner_role_ssm_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.github_runner_role[0].name
# }