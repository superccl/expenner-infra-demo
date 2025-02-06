
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  environment = "prod"
  tags = {
    Tier        = "02b-acm"
    Environment = "prod"
    Created_by  = "Terraform"
    Region      = var.region
  }
}

data "cloudflare_zone" "selected" {
  name = var.root_domain
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  tags = merge(local.tags, {
    Name = "${var.app_name}-acm-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.cloudflare_zone.selected.id
  name    = each.value.name
  type    = each.value.type
  content = each.value.record
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in cloudflare_record.validation : record.hostname]

  lifecycle {
    create_before_destroy = true
  }
}
