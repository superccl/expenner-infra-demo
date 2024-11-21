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
variable "user_pool_name" {
  description = "Name of the user pool"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}
variable "google_client_id" {
  description = "Google client ID"
  type        = string
}
variable "google_client_secret" {
  description = "Google client secret"
  type        = string
}
