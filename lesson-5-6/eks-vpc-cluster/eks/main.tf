module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.project_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id     
  subnet_ids = var.subnet_ids 

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    cpu = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      labels         = { type = "cpu" }
    }

    gpu = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      labels         = { type = "gpu" }
    }
  }
}