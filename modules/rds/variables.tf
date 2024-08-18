variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "The Subnet ID"
  type        = list(string)
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "identifier" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "allocated_storage" {
  description = "RDS DB Instance Identifier"
  type        = number
}

variable "storage_type" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "engine" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "engine_version" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "instance_class" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "parameter_group_name" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "skip_final_snapshot" {
  description = "RDS DB Instance Identifier"
  type        = bool
}