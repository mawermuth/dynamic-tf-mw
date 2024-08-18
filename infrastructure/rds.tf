module "rds" {
  source = "../modules/rds"

  infra_env      = var.infra_env
  vpc_id         = module.vpc.vpc_id
  public_subnets = keys(module.vpc.vpc_public_subnets)

  # RDS DATA
  identifier           = var.rds_data.identifier
  allocated_storage    = var.rds_data.allocated_storage
  storage_type         = var.rds_data.storage_type
  engine               = var.rds_data.engine
  engine_version       = var.rds_data.engine_version
  instance_class       = var.rds_data.instance_class
  parameter_group_name = var.rds_data.parameter_group_name
  skip_final_snapshot  = var.rds_data.skip_final_snapshot
}
