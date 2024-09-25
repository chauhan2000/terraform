locals {
  project_name     = "TerraCopter"
  aws_region       = "ap-south-1"
  vpc_cidr         = "172.7.0.0/16"
  vpc_name         = "TerraCopter-dev-vpc"
  environment      = "dev"
  alb_subnet_cidrs = ["172.7.1.0/24", "172.7.2.0/24", "172.7.3.0/24"]
  app_subnet_cidrs = ["172.7.4.0/24", "172.7.5.0/24", "172.7.6.0/24"]
  db_subnet_cidrs  = ["172.7.7.0/24", "172.7.8.0/24", "172.7.9.0/24"]
  additional_tags = {
    Project     = "TerraCopter"
    Owner       = "Rachit"
    Owner_email = "rachitchauhan2000@gmail.com"
  }
}