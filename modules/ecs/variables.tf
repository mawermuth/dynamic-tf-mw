variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "name" {
  description = "The ECS Object Data"
  type        = string
}

variable "cloud_watch_group_name" {
  description = "The ECS Object Data"
  type        = string
}

variable "setting" {
  description = "The ECS Object Data"
  type = object({
    name  = string
    value = string
  })
}

variable "configuration" {
  description = "The ECS Object Data"
  type = object({
    logging        = string
    log_encryption = bool
  })
}

variable "task_definition" {
  description = "The ECS Task definition object data"
  type        = any
}

variable "service" {
  description = "The ECS Object Data"
  type = list(
    object({
      name                 = string
      desired_count        = number
      task_definition_name = string
      ordered_placement_strategy = object({
        type  = string
        field = string
      })

      create_ecs_load_balancer = bool
      create_service_connect   = bool

      load_balancer = object({
        container_name = string
        container_port = number
      })

      placement_constraints = object({
        type       = string
        expression = string
      })
    })
  )
}

variable "capacity" {
  description = "The ECS Object Data"
  type = object({
    capacity_providers = list(string)
    base               = number
    weight             = number
    capacity_provider  = string
  })
}

# variable "api_gateway_data" {
#   description = "The api gateway Object Data"
#   type = object({
#     api_name          = string
#     api_protocol_type = string

#     stage_name             = string
#     stage_auto_deploy_bool = bool

#     vpc_link_name = string

#     integration_type   = string
#     integration_method = string
#     connection_type    = string

#     route_key = string
#   })
# }

variable "lb" {
  description = "Load balancer baisc configurations."
  type = object({
    name                       = string
    internal                   = bool
    load_balancer_type         = string
    enable_deletion_protection = bool
  })
}

variable "lb_tg_data" {
  description = "Load balancer target group port mappings and type."
  type = object({
    name        = string
    port        = number
    protocol    = string
    target_type = string
  })
}

variable "lb_tg_listener_data" {
  description = "Target group listener configurations."
  type = object({
    port     = string
    protocol = string
    default_action = object({
      type = string
    })
    certificate_arn = string
  })
}

variable "public_subnets" {
  description = "public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "private subnets"
  type        = list(string)
}

variable "public_security_group" {
  description = "public security group"
  type        = string
}

variable "private_security_group" {
  description = "private security group"
  type        = string
}

variable "public_security_group_api" {
  description = "public security group"
  type        = string
}

variable "api_endpoint" {
  description = "public security group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}