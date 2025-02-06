locals {
  name_prefix   = "${var.app_name}-${var.environment}"
  s3_origin_id  = "S3 Origin"
  app_domain_id = "ALB Origin"
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
