module "eks" {
  source = "../modules/eks"

  public_subnets            = keys(module.vpc.vpc_public_subnets)
  private_subnets           = keys(module.vpc.vpc_private_subnets)
  public_security_group     = module.vpc.security_group_public
  private_security_group    = module.vpc.security_group_private
  public_security_group_api = module.vpc.security_group_public_api
  vpc_id                    = module.vpc.vpc_id

  infra_env = var.infra_env

  for_each = {
    for eks, name in var.eks_data : eks => name
  }

  cluster_name                          = each.key
  ami_type                              = each.value.ami_type
  attach_cluster_primary_security_group = each.value.attach_cluster_primary_security_group

  min_size     = each.value.min_size
  max_size     = each.value.max_size
  desired_size = each.value.desired_size

  instance_types_default = each.value.instance_types_default
  instance_types         = each.value.instance_types
  capacity_type          = each.value.capacity_type
  public_access          = each.value.public_access
}