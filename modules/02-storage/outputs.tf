output "web_bucket_id" {
  description = "The ID of the web bucket"
  value       = aws_s3_bucket.web.id
}
output "web_bucket_name" {
  description = "The name of the web bucket"
  value       = aws_s3_bucket.web.bucket
}
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}
output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = "${local.name_prefix}-server"
}
