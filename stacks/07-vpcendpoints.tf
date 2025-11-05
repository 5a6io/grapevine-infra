# vpce
module "sg" {
  source                    = "../modules/edge/vpc-endpoints"
  name                      = var.name
  common_tags               = var.common_tags
  region                    = var.region
  private_subnet_ids        = module.subnets.private_subnet_ids
  private_route_table_ids   = module.igw_nat.private_route_table_ids
}