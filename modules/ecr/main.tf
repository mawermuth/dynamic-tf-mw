resource "aws_ecr_repository" "ecr" {

  name                 = var.ecr_name
  image_tag_mutability = var.image_mutability
  force_delete         = true

  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "image_lifecycle_rule" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire images older than 30 days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}