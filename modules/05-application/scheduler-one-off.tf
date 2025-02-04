resource "aws_scheduler_schedule" "one-off" {
  name                = "${local.name_prefix}-one-off"
  description         = "Initial trigger to run ECS task"
  schedule_expression = "at(${replace(timeadd(timestamp(), "3m"), "Z", "")})"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_ecs_cluster.app.arn
    role_arn = aws_iam_role.scheduler_role.arn

    ecs_parameters {
      task_definition_arn = trimsuffix(aws_ecs_task_definition.batch.arn, ":${aws_ecs_task_definition.batch.revision}")
      task_count          = 1
      launch_type         = "FARGATE"
      network_configuration {
        subnets          = var.application_subnet_ids
        security_groups  = [var.ecs_service_sg_id]
        assign_public_ip = false
      }
    }

    retry_policy {
      maximum_event_age_in_seconds = 86400
      maximum_retry_attempts       = 0
    }
  }

  lifecycle {
    ignore_changes = [
      schedule_expression
    ]
  }
}
