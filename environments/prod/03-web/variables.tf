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
variable "header_name" {
  description = "Custom header name in cloudfront to be passed to the application tier"
  type        = string
}
variable "header_value" {
  description = "Custom header value in cloudfront to be passed to the application tier"
  type        = string
}
variable "cloudfront_price_class" {
  description = "Price class for cloudfront distribution"
  type        = string
  default     = "PriceClass_200"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "Invalid price class"
  }
}
variable "allowed_ips" {
  description = "List of allowed IPs for the AWS WAF before the CloudFront distribution"
  type        = list(string)
  default     = []
}
variable "is_ipv6_enabled" {
  description = "Enable IPv6 for the CloudFront distribution"
  type        = bool
  default     = false
}
variable "container_port" {
  description = "Port for the server to listen on"
  type        = number
  default     = 80
}
variable "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  type        = string

}
variable "s3_backend_networking_key" {
  description = "S3 key for the networking backend"
  type        = string
}
variable "s3_backend_storage_key" {
  description = "S3 key for the s3 web backend"
  type        = string
}
variable "s3_backend_region" {
  description = "S3 region for the backend"
  type        = string
}
