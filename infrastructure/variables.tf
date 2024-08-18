### ECR ###

variable "ecr_list_data" {
  description = "ECR list data, with a list of all the ecr repos needed."
  type = list(
    object({
      ecr_name         = string
      image_mutability = string
    })
  )
  default = []
}

### ECS ###

variable "ecs_data" {
  type        = any
  description = "ECS object data, a object with the keys and data for ECS configuration."
}

### EKS ###

variable "eks_data" {
  type        = any
  description = "EKS object data, a object with the keys and data for EKS configuration."
}

### LOAD BALANCER(LB) ###

variable "load_balancer_data" {
  type = object({
    lb = object({
      name                       = string
      internal                   = bool
      load_balancer_type         = string
      enable_deletion_protection = bool
    })
    lb_tg_data = object({
      name        = string
      port        = number
      protocol    = string
      target_type = string
    })
    lb_tg_listener_data = object({
      port     = string
      protocol = string
      default_action = object({
        type = string
      })
      certificate_arn = string
    })
  })
  description = "Load Balancer data, object with basic data for load balancer, target group and listener."
}

### CLOUDFRONT ###

variable "cloudfront_data" {
  type        = any
  description = "Cloudfront Object Data."
}

### API GATEWAY ###

variable "api_gateway_data" {
  type        = any
  description = "Api Gateway object data, a object with the keys and data for api gateway configuration."
}

### RDS ###

variable "rds_data" {
  description = "RDS DB Data"
  type = object({
    identifier           = string
    allocated_storage    = number
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    parameter_group_name = string
    skip_final_snapshot  = bool
  })
}

### S3 DATA ###

variable "s3_data" {
  type        = any
  description = "S3 Module data variable"
}

### PROJECT ###

variable "ec2_namespace" {
  type        = string
  default     = "ec2"
  description = "The prefix to resource names"
}

variable "aws" {
  type = any
  default = {
    region = "us-east-1"
  }
}

variable "infra_env" {
  description = "Environment variable to define the stack to deploy"
  type        = string
  default     = ""
}

variable "environment_abbreviation" {
  type        = string
  description = "dev, prd, prod, qa etc."
  default     = "loc"
}

variable "environment_name" {
  type        = string
  description = "development, integration, staging, production etc."
  default     = "local"
}

variable "deployment_context" {
  type        = string
  default     = ""
  description = "Deployment namespace suffix, to descriminate different instances of particular deployments (pr/release/version)"
}

variable "namespace" {
  type        = string
  description = "project namespace."
}

variable "authors" {
  type        = string
  description = "The name of the authors"
}

variable "owners" {
  type        = string
  description = "The name of the owners"
}

variable "project" {
  type        = string
  description = "The name of the Project"
}
