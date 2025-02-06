output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "ssm_db_password_name" {
  description = "The name of the SSM parameter for the database password"
  value       = aws_ssm_parameter.db_password.name
}

output "redis_endpoint" {
  description = "The endpoint of the Redis cluster"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

