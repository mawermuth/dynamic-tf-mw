variable "infra_env" {
  type        = string
  description = "infrastructure environment"
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

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "ami_type" {
  description = "AMI Type for instances"
  type        = string
}

variable "public_access" {
  description = "Cluster endpoint public access"
  type        = bool
}

variable "instance_types_default" {
  description = "Kubernetes node group instace types array default"
  type        = list(string)
}

variable "instance_types" {
  description = "Kubernetes instace types array"
  type        = list(string)
}

variable "attach_cluster_primary_security_group" {
  description = "Boolean to attach cluster primary security group"
  type        = bool
}

variable "min_size" {
  description = "Eks node groups mininum size"
  type        = number
}

variable "max_size" {
  description = "Eks node groups maximum size"
  type        = number
}

variable "desired_size" {
  description = "Eks node groups desired size"
  type        = number
}

variable "capacity_type" {
  description = "Eks node group capacity type"
  type        = string
}