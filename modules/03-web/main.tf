locals {
  name_prefix    = "${var.app_name}-${var.environment}"
  hosted_zone_id = try(data.aws_route53_zone.selected.zone_id, aws_route53_zone.primary[0].zone_id)
  tags = {
    Tier        = "03-web"
    Environment = var.environment
    Created_by  = "Terraform"
    Region      = var.region
  }
}

data "aws_s3_bucket" "web" {
  bucket = var.web_bucket_name
}

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}
