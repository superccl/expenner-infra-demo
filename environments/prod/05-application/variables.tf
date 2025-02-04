variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "profile" {
  description = "AWS profile to use"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}
variable "container_name" {
  description = "The name of the container"
  type        = string
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
variable "s3_backend_bucket" {
  description = "S3 bucket for the backend"
  type        = string

}
variable "s3_backend_networking_key" {
  description = "S3 key for the networking backend"
  type        = string
}
variable "s3_backend_storage_key" {
  description = "S3 key for the storage backend"
  type        = string
}
variable "s3_backend_cognito_key" {
  description = "S3 key for the cognito backend"
  type        = string
}
variable "s3_backend_web_key" {
  description = "S3 key for the web backend"
  type        = string
}
variable "s3_backend_data_key" {
  description = "S3 key for the data backend"
  type        = string
}
variable "s3_backend_region" {
  description = "S3 region for the backend"
  type        = string
}
variable "ec2_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"

}

// ECS task environment variables
variable "postgres_host_auth_method" {
  description = "Postgres host auth method"
  type        = string
}
variable "cors_allowed_methods" {
  description = "CORS allowed methods"
  type        = string
}
variable "cors_allowed_headers" {
  description = "CORS allowed headers"
  type        = string
}
variable "cors_exposed_headers" {
  description = "CORS exposed headers"
  type        = string
}
# variable "server_servlet_context_path" {
#   description = "Server servlet context path"
#   type        = string
# }
variable "ecr_image_tag" {
  description = "The tag for the ECR image"
  type        = string
  default     = "latest"
}
# variable "jpa_hibernate_ddl_auto" {
#   description = "JPA hibernate DDL auto"
#   type        = string
#   validation {
#     condition     = can(regex("none|create|create-drop|validate|update", var.jpa_hibernate_ddl_auto))
#     error_message = "Invalid value for jpa_hibernate_ddl_auto"
#   }
# }
variable "debug" {
  description = "Debug mode"
  type        = string
  default     = "False"

}

variable "secret_key" {
  description = "Secret key for the django application"
  type        = string
}

variable "nat_instance_type" {
  description = "The instance type for the NAT instances"
  type        = string
  default     = "t3.micro"
}

variable "admin_email" {
  description = "Admin email for the application"
  type        = string
}
