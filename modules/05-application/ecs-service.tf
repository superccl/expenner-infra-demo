resource "aws_ecs_service" "app" {
  name                    = "${local.name_prefix}-service"
  cluster                 = aws_ecs_cluster.app.id
  task_definition         = aws_ecs_task_definition.app.arn
  desired_count           = var.desired_count
  enable_ecs_managed_tags = true

  network_configuration {
    subnets         = var.application_subnet_ids
    security_groups = [var.ecs_service_sg_id]
    # assign_public_ip = true # for fargate only
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-service"
  })
}
