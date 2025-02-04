terraform {
  backend "s3" {}
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
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

data "terraform_remote_state" "web" {
  backend = "s3"
  config = {
    bucket  = var.s3_backend_bucket
    key     = var.s3_backend_web_key
    region  = var.s3_backend_region
    profile = var.profile
  }
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  subdomain   = var.domain_name == var.root_domain ? "@" : replace(var.domain_name, "/^([^.]+)\\.([^.]+\\.[^.]+)$/", "$1")
  environment = "dev"
}


