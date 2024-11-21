terraform {
  backend "s3" {
    bucket         = "authful-dev-tf-state-1028"
    key            = "05-application/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "authful-terraform-state-lock"
    encrypt        = true
    profile        = "superccl-development"
  }
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
  environment = "dev"
  ecs_task_environment = {
    "SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_JWK_SET_URI" : "https://${data.terraform_remote_state.cognito.outputs.cognito_user_pool_jwk}",
    "SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_ISSUER_URI" : "https://${data.terraform_remote_state.cognito.outputs.cognito_user_pool_issuer_url}",
    "SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_CLIENT_ID" : data.terraform_remote_state.cognito.outputs.cognito_user_pool_server_client_id,
    "SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_CLIENT_SECRET" : data.terraform_remote_state.cognito.outputs.cognito_user_pool_server_client_secret,
    "POSTGRES_USER" : data.aws_db_instance.main.master_username,
    "POSTGRES_PASSWORD" : data.aws_ssm_parameter.db_password.value,
    "POSTGRES_HOST" : data.aws_db_instance.main.address,
    "POSTGRES_PORT" : data.aws_db_instance.main.port,
    "POSTGRES_DB" : data.aws_db_instance.main.db_name,
    "POSTGRES_HOST_AUTH_METHOD" : var.postgres_host_auth_method,
    "CORS_ALLOWED_ORIGINS" : "https://${var.domain_name}",
    "CORS_ALLOWED_METHODS" : var.cors_allowed_methods,
    "CORS_ALLOWED_HEADERS" : var.cors_allowed_headers,
    "CORS_EXPOSED_HEADERS" : var.cors_exposed_headers,
    "SERVER_SERVLET_CONTEXT_PATH" : var.server_servlet_context_path
  }
}


module "application" {
  source                 = "../../../modules/05-application"
  environment            = local.environment
  region                 = var.region
  app_name               = var.app_name
  domain_name            = data.terraform_remote_state.web.outputs.domain_name
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  application_subnet_ids = data.terraform_remote_state.networking.outputs.web_subnet_ids
  container_port         = data.terraform_remote_state.web.outputs.container_port
  container_name         = var.container_name
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory
  desired_count          = var.desired_count
  alb_security_group_id  = data.terraform_remote_state.networking.outputs.web_lb_sg_id
  target_group_arn       = data.terraform_remote_state.web.outputs.target_group_arn
  ec2_instance_type      = var.ec2_instance_type
  ecs_service_sg_id      = data.terraform_remote_state.networking.outputs.ecs_service_sg_id
  ecs_node_sg_id         = data.terraform_remote_state.networking.outputs.ecs_node_sg_id
  ecr_repository_url     = data.terraform_remote_state.storage.outputs.ecr_repository_url
  db_instance_identifier = data.terraform_remote_state.data.outputs.db_instance_identifier
  ecs_task_environment   = local.ecs_task_environment
  ecr_image_tag          = var.ecr_image_tag
}
