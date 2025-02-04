variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string

}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "database_subnet_ids" {
  description = "The IDs of the database subnets"
  type        = list(string)
}
variable "redis_subnet_ids" {
  description = "The IDs of the Redis subnets"
  type        = list(string)

}
variable "db_identifier" {
  description = "Identifier for the database"
  type        = string
  default     = ""
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
variable "ecs_service_sg_id" {
  description = "The ID of the security group for the ECS service"
  type        = string
}
variable "db_sg_id" {
  description = "The ID of the security group for the database"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false

}

variable "redis_node_type" {
  description = "The node type for the Redis instance"
  type        = string
  default     = "cache.t3.micro"

}
variable "redis_port" {
  description = "Port for the Redis instance"
  type        = number
  default     = 6379
}
variable "redis_sg_id" {
  description = "The ID of the security group for the Redis cluster"
  type        = string
}
