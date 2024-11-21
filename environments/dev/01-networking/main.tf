terraform {
  backend "s3" {
    bucket         = "authful-dev-tf-state-1028"
    key            = "01-networking/terraform.tfstate"
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

locals {
  environment = "dev"
}

module "networking" {
  source                  = "../../../modules/01-networking"
  region                  = var.region
  environment             = local.environment
  app_name                = var.app_name
  cidr_block              = var.cidr_block
  num_azs                 = var.num_azs
  web_subnet_cidr         = var.web_subnet_cidr
  application_subnet_cidr = var.application_subnet_cidr
  database_subnet_cidr    = var.database_subnet_cidr
  container_port          = var.container_port
  db_port                 = var.db_port
  my_ip_set               = var.my_ip_set
  lb_ingress_cidr_blocks  = var.lb_ingress_cidr_blocks
}
