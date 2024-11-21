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
variable "my_ip_set" {
  description = "List of CIDR blocks to allow SSH access to the application"
  type        = list(string)
  default     = []
}
variable "lb_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow access to the load balancer"
  type        = list(string)
}

