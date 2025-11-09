# # rds
# module "rds" {
#   source          = "../modules/database/rds"
#   name            = var.name
#   common_tags     = var.common_tags
  
#   private_subnet_ids = module.subnets.private_subnet_ids
#   db_username = var.db_username
#   db_password = var.db_password
#   db_name     = var.db_name

#   engine_version = var.engine_version
#   instance_class = var.instance_class
#   rds_backup_day = var.rds_backup_day 

#   proxy_idle_client_timeout = var.proxy_idle_client_timeout

#   rds_proxy_role       = module.iam.rds_proxy_role
#   rds_proxy_secret_arn = module.secretsmanager.rds_proxy_secret_arn
#   proxy_borrow_timeout = var.proxy_borrow_timeout

#   sg_rds_id       = module.sg.sg_rds_id
#   sg_rds_proxy_id = module.sg.sg_rds_proxy_id
# }