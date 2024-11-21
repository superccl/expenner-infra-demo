locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "05-application"
    Environment = var.environment
    Create_date = formatdate("YYYY-MM-DD", timestamp())
    Created_by  = "Terraform"
    Region      = var.region
  }
}
