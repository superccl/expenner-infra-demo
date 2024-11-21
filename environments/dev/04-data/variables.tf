variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "profile" {
  description = "AWS profile to use"
  type        = string
}
variable "db_identifier" {
  description = "Identifier of the database"
  type        = string
}
variable "db_name" {
  description = "Name of the database"
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
  description = "Username for the database"
  type        = string
}
variable "db_password" {
  description = "Password for the database"
  type        = string
}
variable "db_port" {
  description = "Port for the database"
  type        = number
  default     = 5432
}
variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t4g.micro"
}
variable "db_allocated_storage" {
  description = "Allocated storage for the database"
  type        = number
  default     = 20
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

