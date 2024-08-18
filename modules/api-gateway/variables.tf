variable "api_name" {
  description = "service data test"
  type        = string
}

variable "api_protocol_type" {
  description = "service data test"
  type        = string
}

variable "stage_name" {
  description = "service data test"
  type        = string
}

variable "stage_auto_deploy_bool" {
  description = "service data test"
  type        = bool
}

variable "vpc_link_name" {
  description = "service data test"
  type        = string
}

variable "integration_uri" {
  description = "service data test"
  type        = string
}

variable "integration_type" {
  description = "service data test"
  type        = string
}

variable "integration_method" {
  description = "service data test"
  type        = string
}

variable "connection_type" {
  description = "service data test"
  type        = string
}

variable "route_key" {
  description = "service data test"
  type        = string
}

variable "subnets" {
  description = "service data test"
  type        = list(string)
}

variable "security_groups" {
  description = "service data test"
  type        = list(string)
}

variable "public_security_group_api" {
  description = "public security group"
  type        = string
}

variable "log_group" {
  description = "cloudwatch log group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "infra_env" {
  description = "Infra environment."
  type        = string
}