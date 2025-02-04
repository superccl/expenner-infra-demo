# https://stackoverflow.com/questions/76033657/aws-elasticache-for-redis-cluster-vs-replication-group
# Should use replication group for Redis cluster (cluster mode disabled)
resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${local.name_prefix}-redis-replication-group"
  description                = "Redis replication group for ${local.name_prefix}"
  node_type                  = var.redis_node_type
  num_cache_clusters         = 1
  port                       = var.redis_port
  parameter_group_name       = "default.redis7"
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [var.redis_sg_id]
  apply_immediately          = true
  automatic_failover_enabled = false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-redis-replication-group"
  })
}

resource "aws_elasticache_subnet_group" "main" {
  name        = "${local.name_prefix}-redis-subnet-group"
  description = "Subnet group for the Redis cluster"
  subnet_ids  = var.redis_subnet_ids
}

resource "aws_cloudwatch_log_group" "redis" {
  name              = "/aws/elasticache/${local.name_prefix}-redis-cluster"
  retention_in_days = 7
  tags = merge(local.tags, {
    Name = "/aws/elasticache/${local.name_prefix}-redis-cluster"
  })
}
