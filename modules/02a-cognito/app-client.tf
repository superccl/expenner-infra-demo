resource "aws_cognito_user_pool_client" "postman" {
  name                                 = "postman-client"
  user_pool_id                         = aws_cognito_user_pool.main.id
  generate_secret                      = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["https://${var.domain_name}/home-2"]
  logout_urls                          = ["https://${var.domain_name}"]
  supported_identity_providers         = ["COGNITO", "Google"]

  depends_on = [aws_cognito_identity_provider.google]
}

resource "aws_cognito_user_pool_client" "server" {
  name                                 = "server-client"
  user_pool_id                         = aws_cognito_user_pool.main.id
  generate_secret                      = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["https://${var.domain_name}/home-2"]
  logout_urls                          = ["https://${var.domain_name}"]
  supported_identity_providers         = ["COGNITO", "Google"]

  depends_on = [aws_cognito_identity_provider.google]
}

resource "aws_cognito_user_pool_client" "web" {
  name                                 = "web-client"
  user_pool_id                         = aws_cognito_user_pool.main.id
  generate_secret                      = false
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = ["https://${var.domain_name}/home-2"]
  logout_urls                          = ["https://${var.domain_name}"]
  supported_identity_providers         = ["COGNITO", "Google"]

  depends_on = [aws_cognito_identity_provider.google]
}
