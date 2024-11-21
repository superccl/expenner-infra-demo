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
variable "web_bucket_name" {
  description = "Name of the S3 bucket for the website"
  type        = string
}
