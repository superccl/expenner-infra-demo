terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

locals {
  environment = "dev"
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_networking_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

module "data" {
  source               = "../../../modules/04-data"
  environment          = local.environment
  region               = var.region
  app_name             = var.app_name
  db_identifier        = var.db_identifier
  db_name              = var.db_name
  vpc_id               = data.terraform_remote_state.networking.outputs.vpc_id
  database_subnet_ids  = data.terraform_remote_state.networking.outputs.database_subnet_ids
  db_storage_type      = var.db_storage_type
  db_username          = var.db_username
  db_password          = var.db_password
  db_port              = var.db_port
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  ecs_service_sg_id    = data.terraform_remote_state.networking.outputs.ecs_service_sg_id
  db_sg_id             = data.terraform_remote_state.networking.outputs.db_sg_id
  publicly_accessible  = var.publicly_accessible
  redis_node_type      = var.redis_node_type
  redis_port           = var.redis_port
  redis_sg_id          = data.terraform_remote_state.networking.outputs.redis_sg_id
  redis_subnet_ids     = data.terraform_remote_state.networking.outputs.redis_subnet_ids
}
