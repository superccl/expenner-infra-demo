locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "03-web"
    Environment = var.environment
    Create_date = formatdate("YYYY-MM-DD", timestamp())
    Created_by  = "Terraform"
    Region      = var.region
  }
}

data "aws_s3_bucket" "web" {
  bucket = var.web_bucket_name
}
