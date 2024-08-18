output "ecs_service_name" {
  value       = [for service in module.ecs-service : service.ecs_service_name]
  description = "ecs service name"
}

output "ecs_name" {
  value       = local.cluster_name
  description = "ecs cluster name"
}

output "lb_arn" {
  value       = module.lb-dynamic.lb_arn
  description = "ecs load balancer arn"
}

output "alb_dns" {
  value       = module.lb-dynamic.lb_dns
  description = "ecs load balancer dns"
}