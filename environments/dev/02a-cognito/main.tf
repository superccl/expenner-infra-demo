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

module "cognito" {
  source               = "../../../modules/02a-cognito"
  region               = var.region
  environment          = local.environment
  user_pool_name       = var.user_pool_name
  domain_name          = var.domain_name
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}
