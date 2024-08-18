variable "name" {
  description = "ECS Service name."
  type        = string
}

variable "desired_count" {
  description = "Service name desired count for number of running tasks."
  type        = number
  default     = 2
}

variable "force_new_deployment" {
  description = "Service bool to determine if when a new task is released the service is gonna be re-deployed."
  type        = bool
  default     = true
}

variable "deployment_maximum_percent" {
  description = "Maximum percentage of the service health."
  type        = number
  default     = 100
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum percentage of the service health."
  type        = number
  default     = 50
}

variable "cluster" {
  description = "ECS Cluster ID that is gonna be associated with the service."
  type        = string
}

variable "task_definition" {
  description = "Task definition ARN that is gonna be deployed with the service."
  type        = string
}

variable "subnets" {
  description = "Map string of the Subnets for the ECS Service."
  type        = list(string)
}

variable "security_groups" {
  description = "Map string of Security Groups for the ECS Service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the LB target group."
  type        = string
}

variable "container_name" {
  description = "Container name for the ECS Service application."
  type        = string
}

variable "container_port" {
  description = "Container port for the service."
  type        = number
}

variable "create_ecs_load_balancer" {
  description = "Boolean ecs load balancer to define if the service is gonna have a LB attached to it."
  type        = bool
}

variable "create_service_connect" {
  description = "Service connect boolean to define if the service is gonna have the service connect configuration activated."
  type        = bool
}

variable "namespace" {
  description = "Service discovery http namespace string to define the namespace that the services are gonna be."
  type        = string
}

variable "cloudwatch_group" {
  description = "Cloudwatch group to insert the logs in."
  type        = string
}

variable "infra_env" {
  description = "Infra environment."
  type        = string
}