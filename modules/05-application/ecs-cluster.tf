resource "aws_ecs_cluster" "app" {
  name = "${local.name_prefix}-fargate-spot"
  tags = merge(local.tags, {
    Name = "${local.name_prefix}-fargate-spot"
  })
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.app.name
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
}
