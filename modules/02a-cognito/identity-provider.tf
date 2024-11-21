resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"
  provider_details = {
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
    authorize_scopes = "email openid profile"
  }
  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

# resource "aws_cognito_identity_provider" "facebook" {
#   user_pool_id  = aws_cognito_user_pool.main.id
#   provider_name = "Facebook"
#   provider_type = "Facebook"
#   provider_details = {
#     client_id     = var.facebook_client_id
#     client_secret = var.facebook_client_secret
#   }
#   attribute_mapping = {
#     email    = "email"
#     username = "id"
#   }
# }
