module "vpc" {
  source = "../modules/vpc"

  infra_env = var.infra_env

  # Note we are /17, not /16
  # So we're only using half of the available
  vpc_cidr = "10.0.0.0/17"
}

locals {
  public_subnets            = module.vpc.vpc_public_subnets
  private_subnets           = module.vpc.vpc_private_subnets
  public_security_group     = module.vpc.security_group_public
  private_security_group    = module.vpc.security_group_private
  public_security_group_api = module.vpc.security_group_public_api
  private_security_group_lb = module.vpc.security_group_private_lb
  logs_endpoint             = module.vpc.logs_endpoint
  vpc_id                    = module.vpc.vpc_id
}