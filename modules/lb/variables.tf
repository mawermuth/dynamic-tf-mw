variable "lb" {
  description = "Load balancer object with top level and basic configuration."
  type = object({
    name                       = string
    internal                   = bool
    load_balancer_type         = string
    enable_deletion_protection = bool
  })
}

variable "lb_tg_data" {
  description = "Load balancer target group object with port mappings, type, protocol and etc."
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

variable "lb_logs_bucket_ownership" {
  description = "Logs bucket ownership configuration"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "public_subnets" {
  description = "public subnets map of numbers(definition can be found in vpc module variables, public_subnet_numbers)."
  type        = list(string)
}

variable "private_subnets" {
  description = "private subnets map of numbers(definition can be found in vpc module variables, private_subnet_numbers)."
  type        = list(string)
}

variable "public_security_group" {
  description = "public security group string id(Ex: sg-00000bf3e14660000)"
  type        = string
}

variable "private_security_group" {
  description = "private security group string id(Ex: sg-00000bf3e14660000)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the network VPC"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/health"
  type        = string
}

variable "deregistration_delay" {
  description = "Deregistration delay time on target group"
  default     = 30
  type        = number
}

variable "nlb_arn" {
  description = "network load balancer arn"
  type        = any
  default     = ""
}

variable "infra_env" {
  description = "Infra environment."
  type        = string
}

variable "public_subnet_numbers" {
  type = map(number)

  description = "Map of AZ to a number that should be used for public subnets"

  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
  }
}