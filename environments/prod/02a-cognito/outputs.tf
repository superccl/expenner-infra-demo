output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_id
}

output "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_arn
}

output "cognito_user_pool_name" {
  description = "The name of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_name
}
output "cognito_user_pool_issuer_url" {
  description = "The issuer URL of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_issuer_url
}
output "cognito_user_pool_jwk" {
  description = "The JSON Web Key Set of the Cognito User Pool"
  value       = module.cognito.cognito_user_pool_jwk
}
output "cognito_user_pool_web_client_id" {
  description = "The ID of the Cognito User Pool web client"
  value       = module.cognito.cognito_user_pool_web_client_id
}

output "cognito_user_pool_server_client_id" {
  description = "The secret of the Cognito User Pool server client"
  value       = module.cognito.cognito_user_pool_server_client_id
}

output "cognito_user_pool_server_client_secret" {
  description = "The secret of the Cognito User Pool server client"
  value       = module.cognito.cognito_user_pool_server_client_secret
  sensitive   = true
}

output "cognito_user_pool_postman_client_id" {
  description = "The secret of the Cognito User Pool postman client"
  value       = module.cognito.cognito_user_pool_postman_client_id
}
