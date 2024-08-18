
variable "project_name" {
  type        = string
  description = "The name of the project"
  validation {
    condition     = length(var.project_name) > 1
    error_message = "Required, must have a sensible value"
  }
}

variable "application_name" {
  type        = string
  description = "The name of the application"
  validation {
    condition     = length(var.application_name) > 1
    error_message = "Required, must have a sensible value"
  }
}

variable "environment_abbreviation" {
  type        = string
  description = "dev, prd, prod, qa etc."
  validation {
    condition     = length(var.environment_abbreviation) > 1
    error_message = "Required, must have a sensible value"
  }
}

variable "deployment_context" {
  type        = string
  description = "Deployment namespace suffix, to descriminate different instances of particular deployments (pr/release/version)"
}