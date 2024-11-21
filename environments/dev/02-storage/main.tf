terraform {
  backend "s3" {
    bucket         = "authful-dev-tf-state-1028"
    key            = "02-storage/terraform.tfstate"
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

module "storage" {
  source          = "../../../modules/02-storage"
  region          = var.region
  environment     = local.environment
  web_bucket_name = var.web_bucket_name
  app_name        = var.app_name
}
