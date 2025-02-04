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

module "storage" {
  source          = "../../../modules/02-storage"
  region          = var.region
  environment     = local.environment
  web_bucket_name = var.web_bucket_name
  app_name        = var.app_name
}
