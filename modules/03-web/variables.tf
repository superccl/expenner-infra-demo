variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "web_subnet_ids" {
  description = "List of web subnet IDs"
  type        = list(string)
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
variable "hosted_zone_id" {
  description = "The ID of the existing hosted zone to use if use_existing_hosted_zone is set to true"
  type        = string
  default     = null
}
variable "allowed_ips" {
  description = "List of allowed IPs for the AWS WAF before the CloudFront distribution"
  type        = list(string)
  default     = []
}
variable "web_bucket_name" {
  description = "Name of the S3 bucket for the web content"
  type        = string
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
variable "web_lb_sg_id" {
  description = "The ID of the security group for the load balancer"
  type        = string
}
