terraform {
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

module "prerequisite" {
  source                    = "../../../modules/00-prerequisite"
  region                    = var.region
  environment               = local.environment
  s3_backend_bucket         = var.s3_backend_bucket
  s3_backend_key            = var.s3_backend_prerequisite_key
  s3_backend_region         = var.s3_backend_region
  s3_backend_dynamodb_table = var.s3_backend_dynamodb_table
}
