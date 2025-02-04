locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "05-application"
    Environment = var.environment
    Created_by  = "Terraform"
    Region      = var.region
  }
}
