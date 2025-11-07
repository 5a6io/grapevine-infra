module "ecr" {
  source = "../modules/compute/ecr"
  name = var.name
  common_tags = var.common_tags
  repositories = var.repositories
}