module "s3" {
  source = "../s3"

  bucket_name       = "halogen-java-h3-planning"
  bucket_versioning = "Enabled"
  bucket_ownership  = "BucketOwnerPreferred"
  bucket_website    = false
  bucket_cors       = false
  bucket_policy     = jsonencode(
    {
    "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AddPublicReadCannedAcl",
          "Effect": "Allow",
          "Principal": {
            "AWS": [
              "*"
            ]
          },
          "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl"
          ],
          "Resource": "*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": [
                "public-read"
              ]
            }
          }
        }
      ]
    }
  )
}

locals {
  s3_bucket_java = module.s3.id
#   s3_bucket_object = module.s3.object
}

resource "aws_s3_bucket_object" "s3_bucket_object_halogen_java" {
  bucket = local.s3_bucket_java
  key = "beanstalk/halogen_java"
  source = "h3-planning/halogen_java_beanstalk-1.0.0.jar"
}

resource "aws_elastic_beanstalk_application" "halogen_java_beanstalk" {
  name = "halogen_java_beanstalk"
  description = "The description of my application"
}

resource "aws_elastic_beanstalk_application_version" "halogen_java_beanstalk_version" {
  application = aws_elastic_beanstalk_application.halogen_java_beanstalk.name
  bucket = local.s3_bucket_java
  key = aws_s3_bucket_object.s3_bucket_object_halogen_java.id
  name = "halogen_java_beanstalk-1.0.0"
}

resource "aws_elastic_beanstalk_environment" "halogen_java_beanstalk_env" {
  name = "halogen_java_beanstalk-dev"
  application = aws_elastic_beanstalk_application.halogen_java_beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.7 running Temurin"
  version_label = aws_elastic_beanstalk_application_version.halogen_java_beanstalk_version.name

    setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "8080"
  }

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = "aws-elasticbeanstalk-ec2-role"
  }

}