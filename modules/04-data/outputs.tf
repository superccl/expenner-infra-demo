output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = aws_db_instance.main.id
}

output "ssm_db_password_name" {
  description = "The name of the SSM parameter for the database password"
  value       = aws_ssm_parameter.db_password.name
}

