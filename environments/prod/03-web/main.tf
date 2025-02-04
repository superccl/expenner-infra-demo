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
  environment = "prod"
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

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "web" {
  source                 = "../../../modules/03-web"
  region                 = var.region
  environment            = local.environment
  app_name               = var.app_name
  cloudfront_price_class = var.cloudfront_price_class
  domain_name            = var.domain_name
  header_name            = var.header_name
  header_value           = var.header_value
  allowed_ips            = ["${chomp(data.http.myip.response_body)}/32"]
  is_ipv6_enabled        = var.is_ipv6_enabled
  container_port         = var.container_port
  vpc_id                 = data.terraform_remote_state.networking.outputs.vpc_id
  web_subnet_ids         = data.terraform_remote_state.networking.outputs.web_subnet_ids
  web_bucket_name        = data.terraform_remote_state.storage.outputs.web_bucket_name
  web_lb_sg_id           = data.terraform_remote_state.networking.outputs.web_lb_sg_id
}
