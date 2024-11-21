// s3 backend
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
// From networking
variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca)\\-\\w+\\-\\d+$", var.region))
    error_message = "The region must be a valid AWS region."
  }
}
variable "profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}
variable "num_azs" {
  description = "Number of availability zones to use"
  type        = number
  default     = 0
}
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "ae"
}
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.16.0.0/20"
}
variable "web_subnet_cidr" {
  description = "CIDR block for web subnet"
  type        = list(string)
  default     = ["10.16.1.0/24", "10.16.2.0/24", "10.16.3.0/24"]

}

variable "application_subnet_cidr" {
  description = "CIDR block for application subnet"
  type        = list(string)
  default     = ["10.16.4.0/24", "10.16.5.0/24", "10.16.6.0/24"]
}

variable "database_subnet_cidr" {
  description = "CIDR block for database subnet"
  type        = list(string)
  default     = ["10.16.7.0/24", "10.16.8.0/24", "10.16.9.0/24"]
}
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}
variable "header_name" {
  description = "Custom header name in cloudfront to be passed to the application tier"
  type        = string
  default     = "X-Custom-Header"
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
  description = "Hosted zone ID for the domain"
  type        = string
  default     = null

}
variable "allowed_ips" {
  description = "List of allowed IPs for the AWS WAF before the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "task_cpu" {
  description = "The number of CPU units for the task"
  type        = number
  default     = 256

}

variable "task_memory" {
  description = "The amount of memory for the task"
  type        = number
  default     = 512
}
variable "desired_count" {
  description = "The number of tasks to run"
  type        = number
  default     = 1
}
variable "image_uri" {
  description = "The URI of the Docker image"
  type        = string

}
variable "debug" {
  description = "Enable debug mode"
  type        = bool
  default     = false
}
variable "secret_key" {
  description = "Secret key for the application"
  type        = string

}
variable "db_storage_type" {
  description = "Storage type for the database"
  type        = string
  default     = "gp2"

  validation {
    condition     = can(regex("^(gp2|gp3|io1|standard)$", var.db_storage_type))
    error_message = "The storage type must be gp2, io1, or standard."

  }
}
variable "db_username" {
  description = "Database username"
  type        = string
}
variable "db_password" {
  description = "Database password"
  type        = string

}
variable "db_port" {
  description = "Port for the database"
  type        = number
  default     = 5432
}
variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"
}
variable "db_allocated_storage" {
  description = "Database allocated storage"
  type        = number
  default     = 20
}
