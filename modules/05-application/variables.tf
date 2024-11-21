variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "environment" {
  description = "Environment for the application"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}
variable "application_subnet_ids" {
  description = "The IDs of the application subnets"
  type        = list(string)
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "container_name" {
  description = "The name of the container"
  type        = string
}
variable "container_port" {
  description = "The port the application listens on"
  type        = number
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
variable "alb_security_group_id" {
  description = "The ID of the security group for the application load balancer in the web tier"
  type        = string
}
variable "target_group_arn" {
  description = "The ARN of the target group for the application load balancer in the web tier"
  type        = string
}
variable "ec2_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}
variable "ecs_service_sg_id" {
  description = "The ID of the security group for the ECS service"
  type        = string
}
variable "ecs_node_sg_id" {
  description = "The ID of the security group for the ECS nodes"
  type        = string
}
variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}
variable "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  type        = string
}
variable "ecs_task_environment" {
  description = "Environment variables for the ECS task"
  type        = map(string)
}
variable "ecr_image_tag" {
  description = "The tag for the ECR image"
  type        = string
  default     = "latest"
}

