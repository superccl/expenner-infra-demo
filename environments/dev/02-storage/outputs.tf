output "web_bucket_id" {
  description = "The ID of the web bucket"
  value       = module.storage.web_bucket_id
}
output "web_bucket_name" {
  description = "The name of the web bucket"
  value       = module.storage.web_bucket_name
}
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.storage.ecr_repository_url
}
output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = module.storage.ecr_repository_name
}
