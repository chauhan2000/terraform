module "dev_vpc" {
  source           = "../../modules/vpc"
  vpc_cidr         = local.vpc_cidr
  alb_subnet_cidrs = local.alb_subnet_cidrs
  app_subnet_cidrs = local.app_subnet_cidrs
  db_subnet_cidrs  = local.db_subnet_cidrs
  environment      = local.environment
  project_name     = local.project_name

  vpc_tags = merge(
    {
      name = local.vpc_name
    }, local.common_tags
  )

  additional_tags = local.additional_tags
}