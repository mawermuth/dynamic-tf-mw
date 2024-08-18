locals {
  project_name             = var.project_name
  application_name         = var.application_name
  environment_abbreviation = var.environment_abbreviation
  deployment_context       = var.deployment_context
  dns_name                 = "${var.project_name}-${var.application_name}-${var.environment_abbreviation}%{if var.deployment_context != ""}-${var.deployment_context}%{endif}"
}