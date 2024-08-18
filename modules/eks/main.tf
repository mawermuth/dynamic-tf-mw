module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                   = var.cluster_name
  cluster_endpoint_public_access = var.public_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    instance_types = var.instance_types_default

    attach_cluster_primary_security_group = var.attach_cluster_primary_security_group
  }

  eks_managed_node_groups = {
    "${var.cluster_name}-${var.infra_env}" = {
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      instance_types = var.instance_types
      capacity_type  = var.capacity_type

      tags = {
        ExtraTag = "dynamic-cluster"
      }
    }
  }

#   tags = local.tags
}