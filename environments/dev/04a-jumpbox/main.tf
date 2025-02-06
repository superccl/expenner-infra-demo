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

module "jumpbox" {
  source        = "../../../modules/04a-jumpbox"
  region        = var.region
  environment   = local.environment
  app_name      = var.app_name
  subnet_id     = data.terraform_remote_state.networking.outputs.application_subnet_ids[0]
  jumpbox_sg_id = data.terraform_remote_state.networking.outputs.jumpbox_sg_id
}
