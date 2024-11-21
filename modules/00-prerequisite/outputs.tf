output "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  value       = var.s3_backend_bucket
}
output "s3_backend_key" {
  description = "S3 key for the backend"
  value       = var.s3_backend_key
}
output "s3_backend_region" {
  description = "S3 region for the backend"
  value       = var.s3_backend_region
}
output "s3_backend_dynamodb_table" {
  description = "DynamoDB table for the backend"
  value       = var.s3_backend_dynamodb_table
}
