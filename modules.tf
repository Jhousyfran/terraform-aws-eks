module "network" {
  source     = "./modules/network"
  prefix     = var.prefix
  project    = var.project
  cidr_block = var.cidr_block
  tags       = local.tags
}
