variable "iam_instance_profile" {
  type        = string
  description = "iam instance profile"
  default     = "instance_profile"
}

variable "key_name" {
  type        = string
  description = "key_name"
  default     = "key_name"
}

variable "user_data" {
  type        = string
  description = "key_name"
  default     = "user_data"
}

variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
  default     = 1
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "infra_role" {
  type        = string
  description = "infrastructure purpose"
}

variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t3.small"
}

variable "instance_ami" {
  type        = string
  description = "Server image to use"
}

variable "instance_root_device_size" {
  type        = number
  description = "Root bock device size in GB"
  default     = 12
}

variable "subnets" {
  type        = list(string)
  description = "valid subnets to assign to server"
}

variable "security_groups" {
  type        = list(string)
  description = "security groups to assign to server"
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for the ec2 instance"
}

variable "create_eip" {
  type        = bool
  default     = false
  description = "whether to create an EIP for the ec2 instance or not"
}