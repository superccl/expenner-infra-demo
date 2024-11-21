locals {
  tags = {
    Tier        = "02a-cognito"
    Environment = var.environment
    Create_date = formatdate("YYYY-MM-DD", timestamp())
    Created_by  = "Terraform"
    Region      = var.region
  }
}

resource "aws_cognito_user_pool" "main" {
  name = var.user_pool_name
  tags = merge(local.tags, {
    Name = "${var.user_pool_name}-user-pool"
  })

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
  username_configuration {
    case_sensitive = true
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }


}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.user_pool_name
  user_pool_id = aws_cognito_user_pool.main.id
}
