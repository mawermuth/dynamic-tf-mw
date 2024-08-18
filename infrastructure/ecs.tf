module "ecs" {
  source = "../modules/ecs"

  infra_env = var.infra_env

  for_each = {
    for ecs in var.ecs_data : var.infra_env => ecs
  }

  name                   = each.value.name
  cloud_watch_group_name = each.value.cloud_watch_group_name

  setting       = each.value.setting
  configuration = each.value.configuration

  task_definition = each.value.task_definition
  service         = each.value.service
  capacity        = each.value.capacity

  public_subnets            = keys(module.vpc.vpc_public_subnets)
  private_subnets           = keys(module.vpc.vpc_private_subnets)
  public_security_group     = module.vpc.security_group_public
  private_security_group    = module.vpc.security_group_private
  public_security_group_api = module.vpc.security_group_public_api
  vpc_id                    = module.vpc.vpc_id

  lb                  = each.value.load_balancer_data.lb
  lb_tg_data          = each.value.load_balancer_data.lb_tg_data
  lb_tg_listener_data = each.value.load_balancer_data.lb_tg_listener_data

  # api_gateway_data = each.value.api_gateway_data
}

locals {
  ecs_name         = module.ecs[var.infra_env].ecs_name
  ecs_service_name = module.ecs[var.infra_env].ecs_service_name
  lb_arn           = module.ecs[var.infra_env].lb_arn
  alb_dns          = module.ecs[var.infra_env].alb_dns
}