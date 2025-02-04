
variable "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  type        = string

}

variable "s3_backend_networking_key" {
  description = "S3 key for the networking backend"
  type        = string
}
variable "s3_backend_web_key" {
  description = "S3 key for the web backend"
  type        = string
}

variable "s3_backend_region" {
  description = "S3 region for the backend"
  type        = string

}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
}

variable "root_domain" {
  description = "Root domain for the Cloudflare DNS"
  type        = string

}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string

}
