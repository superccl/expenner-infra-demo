
output "task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = module.application.task_execution_role_arn
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.application.ecs_cluster_arn
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service"
  value       = module.application.ecs_service_arn
}

output "task_definiton_arn" {
  description = "The ARN of the ECS task definition"
  value       = module.application.task_definiton_arn
}

output "batch_task_definition_arn" {
  description = "The ARN of the ECS batch task definition"
  value       = module.application.batch_task_definition_arn
}
