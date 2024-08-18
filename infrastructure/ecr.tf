module "ecr-repo" {
  source = "../modules/ecr"

  for_each = {
    for ecr_repo in var.ecr_list_data : ecr_repo.ecr_name => ecr_repo
  }

  ecr_name         = "${each.value.ecr_name}-${var.infra_env}"
  image_mutability = each.value.image_mutability
}