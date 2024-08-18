module "lb-dynamic" {
  source = "../modules/lb"

  infra_env              = var.infra_env
  public_subnets         = keys(module.vpc.vpc_public_subnets)
  private_subnets        = keys(module.vpc.vpc_private_subnets)
  public_security_group  = module.vpc.security_group_private_lb
  private_security_group = module.vpc.security_group_private
  vpc_id                 = module.vpc.vpc_id
  lb                     = var.load_balancer_data.lb
  lb_tg_data             = var.load_balancer_data.lb_tg_data
  lb_tg_listener_data    = var.load_balancer_data.lb_tg_listener_data
  nlb_arn                = module.ecs[var.infra_env].lb_arn
}