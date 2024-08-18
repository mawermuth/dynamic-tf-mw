provider "aws" {
  region = "us-east-1"
}

locals {
  authors   = var.authors
  owners    = var.owners
  project   = var.project
  namespace = var.namespace
}

module "backend-init" {
  source    = "../modules/backend-init"
  namespace = var.namespace
}
