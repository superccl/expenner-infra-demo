output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}
output "web_subnet_ids" {
  description = "The IDs of the web subnets"
  value       = module.networking.web_subnet_ids
}

output "application_subnet_ids" {
  description = "The IDs of the application subnets"
  value       = module.networking.application_subnet_ids
}

output "database_subnet_ids" {
  description = "The IDs of the database subnets"
  value       = module.networking.database_subnet_ids
}

output "redis_subnet_ids" {
  description = "The IDs of the Redis subnets"
  value       = module.networking.redis_subnet_ids
}

output "web_subnet_cidr_blocks" {
  description = "The CIDR blocks of the web subnets"
  value       = module.networking.web_subnet_cidr_blocks
}

output "application_subnet_cidr_blocks" {
  description = "The CIDR blocks of the application subnets"
  value       = module.networking.application_subnet_cidr_blocks
}

output "database_subnet_cidr_blocks" {
  description = "The CIDR blocks of the database subnets"
  value       = module.networking.database_subnet_cidr_blocks
}

output "redis_subnet_cidr_blocks" {
  description = "The CIDR blocks of the Redis subnets"
  value       = module.networking.redis_subnet_cidr_blocks
}

output "azs" {
  description = "The availability zones"
  value       = module.networking.azs
}

output "web_lb_sg_id" {
  description = "The ID of the security group for the load balancer"
  value       = module.networking.web_lb_sg_id
}

output "ecs_service_sg_id" {
  description = "The ID of the security group for the ECS service"
  value       = module.networking.ecs_service_sg_id
}

output "vpc_endpoints_sg_id" {
  description = "The ID of the security group for the VPC endpoints"
  value       = module.networking.vpc_endpoints_sg_id
}

output "ecs_node_sg_id" {
  description = "The ID of the security group for the ECS nodes"
  value       = module.networking.ecs_node_sg_id
}

output "db_sg_id" {
  description = "The ID of the security group for the database"
  value       = module.networking.db_sg_id
}

output "redis_port" {
  description = "The port for the Redis cluster"
  value       = var.redis_port
}

output "redis_sg_id" {
  description = "The ID of the security group for the Redis cluster"
  value       = module.networking.redis_sg_id
}
