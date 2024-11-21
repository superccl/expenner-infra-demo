variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca)\\-\\w+\\-\\d+$", var.region))
    error_message = "The region must be a valid AWS region."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  type        = string

}
variable "s3_backend_key" {
  description = "S3 key for the backend"
  type        = string
}
variable "s3_backend_region" {
  description = "S3 region for the backend"
  type        = string
}
variable "s3_backend_dynamodb_table" {
  description = "DynamoDB table for the backend"
  type        = string
}
