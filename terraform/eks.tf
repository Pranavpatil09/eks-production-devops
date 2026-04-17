module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  # Use version constraints, but currently it's fetching latest
  name               = "pranav-prod-eks"
  kubernetes_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    prod = {
      instance_types = ["t2.micro"]
      desired_size   = 2
      min_size       = 1
      max_size       = 4
    }
  }
}
