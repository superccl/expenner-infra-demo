variable "profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}
variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca)\\-\\w+\\-\\d+$", var.region))
    error_message = "The region must be a valid AWS region."
  }
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  type        = string
}
variable "s3_backend_networking_key" {
  description = "S3 key for the networking backend"
  type        = string
}
variable "s3_backend_region" {
  description = "S3 region for the backend"
  type        = string
}
