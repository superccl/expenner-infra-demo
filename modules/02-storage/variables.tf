variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "web_bucket_name" {
  description = "Name of the S3 bucket for the website"
  type        = string
}
