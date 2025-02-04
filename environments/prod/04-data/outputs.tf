output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = module.data.db_instance_identifier
}

output "ssm_db_password_name" {
  description = "The name of the SSM parameter for the database password"
  value       = module.data.ssm_db_password_name
}

output "redis_endpoint" {
  description = "The endpoint of the Redis cluster"
  value       = module.data.redis_endpoint
}

