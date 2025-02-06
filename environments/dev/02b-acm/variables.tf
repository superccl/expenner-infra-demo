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
variable "domain_name" {
  description = "Domain name for the application"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-.]+$", var.domain_name))
    error_message = "Domain name must be lowercase alphanumeric characters and hyphens only"
  }
}
variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
}
variable "root_domain" {
  description = "Root domain for the Cloudflare DNS"
  type        = string
}
