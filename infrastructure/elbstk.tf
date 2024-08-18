module "elastic-beanstalk" {
  source = "../modules/elbstk"

  infra_env = var.infra_env
}