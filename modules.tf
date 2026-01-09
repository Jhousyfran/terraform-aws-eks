module "network" {
  source     = "./modules/network"
  prefix     = var.prefix
  project    = var.project
  cidr_block = var.cidr_block
  tags       = local.tags
}

module "eks_cluster" {
  source  = "./modules/cluster"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  public_subnet_1a_id = module.network.eks_subnet_public_1a_id
  public_subnet_1b_id = module.network.eks_subnet_public_1b_id

}
