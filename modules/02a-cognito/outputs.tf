output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "cognito_user_pool_name" {
  description = "The name of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.name
}
output "cognito_user_pool_issuer_url" {
  description = "The issuer URL of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.endpoint
}
output "cognito_user_pool_jwk" {
  description = "The JSON Web Key Set of the Cognito User Pool"
  value       = "${aws_cognito_user_pool.main.endpoint}/.well-known/jwks.json"
}
output "cognito_user_pool_web_client_id" {
  description = "The ID of the Cognito User Pool web client"
  value       = aws_cognito_user_pool_client.web.id
}

output "cognito_user_pool_server_client_id" {
  description = "The secret of the Cognito User Pool server client"
  value       = aws_cognito_user_pool_client.server.id
}

output "cognito_user_pool_server_client_secret" {
  description = "The secret of the Cognito User Pool server client"
  value       = aws_cognito_user_pool_client.server.client_secret
  sensitive   = true
}

output "cognito_user_pool_postman_client_id" {
  description = "The secret of the Cognito User Pool postman client"
  value       = aws_cognito_user_pool_client.postman.id
}
