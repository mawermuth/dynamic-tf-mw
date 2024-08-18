### VPC ###

output "vpc_id" {
  value       = local.vpc_id
  description = "private security group"
}

output "security_group_public" {
  value = module.vpc.security_group_public
}

output "security_group_private" {
  value = module.vpc.security_group_private
}

output "security_group_private_lb" {
  value = module.vpc.security_group_private_lb
}

output "logs_endpoint" {
  value = module.vpc.logs_endpoint
}

output "public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "private_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "public_security_group_api" {
  value       = local.public_security_group_api
  description = "public security group"
}

### CLOUDFRONT ###

output "cloudfront_bucket_name" {
  value = module.cloudfront.cloudfront_aws_s3_bucket
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}

### ECS ###

output "ecs_service_name" {
  value = module.ecs[var.infra_env].ecs_service_name
}

output "ecs_name" {
  value = module.ecs[var.infra_env].ecs_name
}

output "ecs_lb_arn" {
  value = module.ecs[var.infra_env].lb_arn
}

output "alb_dns" {
  value = module.ecs[var.infra_env].alb_dns
}

### EKS ###

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = [for cluster in module.eks : cluster.cluster_endpoint]
}

output "eks_cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = [for cluster in module.eks : cluster.cluster_security_group_id]
}

output "eks_cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = [for cluster in module.eks : cluster.cluster_name]
}

### LOAD BALANCER(LB) ###

output "lb_dns" {
  value = module.lb-dynamic.lb_dns
}

output "api_lb_arn" {
  value       = local.lb_arn
  description = "api gateway url"
}

### RDS ###

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_instance_arn" {
  value = module.rds.db_instance_arn
}

output "secret_arn" {
  value = module.rds.secret_arn
}

### EC2 ###

# output "web_public_ip" {
#   value       = local.web_public_ip
#   description = "EC2 Web Public IP Address"
# }

# output "user_data" {
#   value       = local.user_data
#   description = "User data for EC2 Web Server"
# }

# output "web_server_name" {
#   value       = local.ec2_name_with_namespace
#   description = "Name (id) of the EC2 Web Server"
# }

### S3 ###

output "bucket_arn" {
  value = {
    for bucket in module.s3 :
    bucket.arn => bucket.arn
  }
  # value = module.s3.arn
}

output "bucket_name" {
  value = {
    for bucket in module.s3 :
    bucket.bucket => bucket.bucket
  }
  # value = module.s3.bucket
}

output "bucket_regional_domain_name" {
  value = {
    for bucket in module.s3 :
    bucket.bucket_regional_domain_name => bucket.bucket_regional_domain_name
  }
  # value = module.s3.bucket_regional_domain_name
}

### BACKEND ###

output "backend_table_name" {
  value = module.backend-init.dynamo_db_table_name
}

output "backend_bucket_name" {
  value = module.backend-init.s3_bucket_name
}

output "backend_bucket_arn" {
  value = module.backend-init.s3_bucket_arn
}