resource "aws_scheduler_schedule" "ecs" {
  name                = "${local.name_prefix}-schedule"
  description         = "Daily trigger to run ECS task"
  schedule_expression = "cron(00 02 * * ? *)"
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
}

resource "aws_iam_role" "scheduler_role" {
  name = "${local.name_prefix}-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "scheduler_policy" {
  name = "${local.name_prefix}-scheduler-policy"
  role = aws_iam_role.scheduler_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RunTask"
        ],
        Resource = [
          trimsuffix(aws_ecs_task_definition.batch.arn, ":${aws_ecs_task_definition.batch.revision}"),
          "${trimsuffix(aws_ecs_task_definition.batch.arn, ":${aws_ecs_task_definition.batch.revision}")}:*"
        ]
        Condition = {
          ArnLike = {
            "ecs:cluster" = aws_ecs_cluster.app.arn
          }
        }
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*"
        Condition = {
          StringLike = {
            "iam:PassedToService" = "ecs-tasks.amazonaws.com"
          }
        }
      }
    ]
  })
}
