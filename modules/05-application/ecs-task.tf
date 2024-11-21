resource "aws_ecs_task_definition" "app" {
  family             = "${local.name_prefix}-task"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  cpu                = var.task_cpu
  memory             = var.task_memory
  container_definitions = jsonencode([
    {
      "name" : var.container_name,
      "image" : "${var.ecr_repository_url}:${var.ecr_image_tag}",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : var.container_port,
          "hostPort" : var.container_port,
          "protocol" : "tcp"
        }
      ],
      "environment" : [
        for key, value in var.ecs_task_environment : {
          "name" : key,
          "value" : value
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/",
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
          "awslogs-create-group" : "true"
          "mode" : "non-blocking"
          "max-buffer-size" : "25m"
        }
      }
    }
  ])
  requires_compatibilities = ["EC2", "FARGATE"]
  network_mode             = "awsvpc"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-task"
  })
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/"
  retention_in_days = 7
  tags = merge(local.tags, {
    Name = "/ecs/"
  })
}
