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

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_networking_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_storage_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "terraform_remote_state" "cognito" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_cognito_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "terraform_remote_state" "web" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_web_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_data_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "aws_db_instance" "main" {
  db_instance_identifier = data.terraform_remote_state.data.outputs.db_instance_identifier
}

data "aws_ssm_parameter" "db_password" {
  name = data.terraform_remote_state.data.outputs.ssm_db_password_name
}

locals {
  environment = "prod"
  ecs_task_environment = {
    "SECRET_KEY" : var.secret_key,
    "COGNITO_USER_POOL" : data.terraform_remote_state.cognito.outputs.cognito_user_pool_id,
    "COGNITO_AWS_REGION" : var.region,
    "COGNITO_APP_CLIENT_ID" : data.terraform_remote_state.cognito.outputs.cognito_user_pool_server_client_id,
    "POSTGRES_DB" : data.aws_db_instance.main.db_name,
    "POSTGRES_USER" : data.aws_db_instance.main.master_username,
    "POSTGRES_PASSWORD" : data.aws_ssm_parameter.db_password.value,
    "POSTGRES_HOST" : data.aws_db_instance.main.address,
    "POSTGRES_PORT" : data.aws_db_instance.main.port,
    "REDIS_HOST" : data.terraform_remote_state.data.outputs.redis_endpoint,
    "REDIS_PORT" : data.terraform_remote_state.networking.outputs.redis_port,
    "REDIS_DB" : "0",
    "CORS_ALLOWED_ORIGINS" : "https://${var.domain_name}",
    "CORS_ALLOW_METHODS" : var.cors_allowed_methods,
    "CORS_ALLOW_HEADERS" : var.cors_allowed_headers,
    "CORS_EXPOSED_HEADERS" : var.cors_exposed_headers,
    "ALLOWED_HOSTS" : ".localhost,127.0.0.1,[::1],.${var.domain_name}",
    # "ADMIN_EMAIL" : var.admin_email,
    "DEBUG" : var.debug,
  }
}


module "application" {
  source                 = "../../../modules/05-application"
  environment            = local.environment
  region                 = var.region
  app_name               = var.app_name
  domain_name            = data.terraform_remote_state.web.outputs.domain_name
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  application_subnet_ids = data.terraform_remote_state.networking.outputs.application_subnet_ids
  container_port         = data.terraform_remote_state.web.outputs.container_port
  container_name         = var.container_name
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory
  desired_count          = var.desired_count
  alb_security_group_id  = data.terraform_remote_state.networking.outputs.web_lb_sg_id
  target_group_arn       = data.terraform_remote_state.web.outputs.target_group_arn
  ec2_instance_type      = var.ec2_instance_type
  ecs_service_sg_id      = data.terraform_remote_state.networking.outputs.ecs_service_sg_id
  vpc_endpoints_sg_id    = data.terraform_remote_state.networking.outputs.vpc_endpoints_sg_id
  ecs_node_sg_id         = data.terraform_remote_state.networking.outputs.ecs_node_sg_id
  ecr_repository_url     = data.terraform_remote_state.storage.outputs.ecr_repository_url
  db_instance_identifier = data.terraform_remote_state.data.outputs.db_instance_identifier
  ecs_task_environment   = local.ecs_task_environment
  ecr_image_tag          = var.ecr_image_tag
}

data "aws_route_table" "app" {
  subnet_id = data.terraform_remote_state.networking.outputs.application_subnet_ids[0]
}
module "nat" {
  source                      = "int128/nat-instance/aws"
  name                        = "nat-instance-main"
  vpc_id                      = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet               = data.terraform_remote_state.networking.outputs.public_subnet_ids[0]
  private_subnets_cidr_blocks = data.terraform_remote_state.networking.outputs.application_subnet_cidr_blocks
  private_route_table_ids     = [data.aws_route_table.app.id]
  instance_types              = [var.nat_instance_type]
  use_spot_instance           = true
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
  tags = {
    "Name" = "nat-instance-main"
  }
}
