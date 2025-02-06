locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "04-data"
    Environment = var.environment
    Created_by  = "Terraform"
    Region      = var.region
  }
}

// VPC Endpoint (ssm)
//ssm.region.amazonaws.com
//ssmmessages.region.amazonaws.com
//ec2messages.region.amazonaws.com
