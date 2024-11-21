output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
output "web_subnet_ids" {
  description = "The IDs of the web subnets"
  value       = [for subnet in aws_subnet.web : subnet.id]
}

output "application_subnet_ids" {
  description = "The IDs of the application subnets"
  value       = [for subnet in aws_subnet.application : subnet.id]
}

output "database_subnet_ids" {
  description = "The IDs of the database subnets"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

output "azs" {
  description = "The availability zones"
  value       = local.selected_azs
}

output "web_lb_sg_id" {
  description = "The ID of the security group for the load balancer"
  value       = aws_security_group.web_lb.id
}

output "ecs_service_sg_id" {
  description = "The ID of the security group for the ECS service"
  value       = aws_security_group.ecs_service.id
}

output "ecs_node_sg_id" {
  description = "The ID of the security group for the ECS nodes"
  value       = aws_security_group.ecs_node.id
}

output "db_sg_id" {
  description = "The ID of the security group for the database"
  value       = aws_security_group.db.id
}


