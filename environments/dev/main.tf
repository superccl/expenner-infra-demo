provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Tier        = "prerequisite"
      Environment = "dev"
      Create_date = formatdate("YYYY-MM-DD", timestamp())
      Created_by  = "Terraform"
      Region      = var.region
    }
  }
}

locals {
  environment = "dev"
}

module "network" {
  app_name                = var.app_name
  cidr_block              = var.cidr_block
  environment             = local.environment
  num_azs                 = var.num_azs
  region                  = var.region
  source                  = "../../modules/network"
  web_subnet_cidr         = var.web_subnet_cidr
  application_subnet_cidr = var.application_subnet_cidr
  database_subnet_cidr    = var.database_subnet_cidr
}

module "web" {
  app_name               = var.app_name
  cloudfront_price_class = var.cloudfront_price_class
  domain_name            = var.domain_name
  environment            = local.environment
  header_name            = var.header_name
  header_value           = var.header_value
  region                 = var.region
  source                 = "../../modules/web"
  vpc_id                 = module.network.vpc_id
  web_subnet_ids         = module.network.web_subnet_ids
  allowed_ips            = var.allowed_ips
}

module "application" {
  app_name               = var.app_name
  domain_name            = var.domain_name
  environment            = local.environment
  region                 = var.region
  source                 = "../../modules/application"
  vpc_id                 = module.network.vpc_id
  application_subnet_ids = module.network.application_subnet_ids
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory
  desired_count          = var.desired_count
  alb_security_group_id  = module.web.alb_security_group_id
  target_group_arn       = module.web.target_group_arn
  image_uri              = var.image_uri
  db_address             = module.data.db_address
  db_identifier          = module.data.db_identifier
  db_username            = var.db_username
  db_password            = var.db_password
  db_port                = var.db_port
  debug                  = var.debug
  secret_key             = var.secret_key
  my_ip_set              = var.allowed_ips
}

module "data" {
  app_name             = var.app_name
  environment          = local.environment
  region               = var.region
  source               = "../../modules/data"
  vpc_id               = module.network.vpc_id
  database_subnet_ids  = module.network.database_subnet_ids
  db_storage_type      = var.db_storage_type
  db_username          = var.db_username
  db_password          = var.db_password
  db_port              = var.db_port
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  ecs_service_sg_id    = module.application.ecs_service_sg_id
}
