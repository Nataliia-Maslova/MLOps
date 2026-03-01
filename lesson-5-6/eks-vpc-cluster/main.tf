module "vpc" {
  source       = "./vpc"
  aws_region   = var.aws_region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "eks" {
  source       = "./eks"
  aws_region   = var.aws_region
  project_name = var.project_name
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}