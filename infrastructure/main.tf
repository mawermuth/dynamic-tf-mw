terraform {
  required_version = ">=1.8.4"
  backend "s3" {
    bucket         = "dynamictf-wermuth-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }
}

# provider "aws" {
#   region = "us-east-1"
#   default_tags {
#     tags = local.project_tags
#   }
# }
