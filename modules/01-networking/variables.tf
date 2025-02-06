variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "num_azs" {
  description = "Number of availability zones to use"
  type        = number
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
variable "public_subnet_cidr" {
  description = "CIDR block for public subnets"
  type        = list(string)
  default     = ["10.16.1.0/24", "10.16.2.0/24"]
}


variable "web_subnet_cidr" {
  description = "CIDR block for web subnets"
  type        = list(string)
  default     = ["10.16.13.0/24", "10.16.14.0/24"]
}

variable "application_subnet_cidr" {
  description = "CIDR block for application subnets"
  type        = list(string)
  default     = ["10.16.4.0/24", "10.16.5.0/24"]
}

variable "database_subnet_cidr" {
  description = "CIDR block for database subnets"
  type        = list(string)
  default     = ["10.16.7.0/24", "10.16.8.0/24"]
}

variable "redis_subnet_cidr" {
  description = "CIDR block for Redis subnets"
  type        = list(string)
  default     = ["10.16.10.0/24", "10.16.11.0/24"]
}

variable "container_port" {
  description = "Port for the server to listen on"
  type        = number
  default     = 80
}
variable "db_port" {
  description = "Port for the database"
  type        = number
  default     = 5432
}
variable "redis_port" {
  description = "Port for the Redis server"
  type        = number
  default     = 6379
}
variable "my_ip_set" {
  description = "List of CIDR blocks to allow SSH access to the application"
  type        = list(string)
  default     = []
}
variable "lb_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow access to the load balancer"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
