locals {
  name_prefix   = "${var.app_name}-${var.environment}"
  db_identifier = var.db_identifier != "" ? var.db_identifier : "${local.name_prefix}-db"
  tags = {
    Tier        = "04-data"
    Environment = var.environment
    Created_by  = "Terraform"
    Region      = var.region
  }
}

# aws rds describe-db-engine-versions --engine postgres --query "DBEngineVersions[].EngineVersion"
data "aws_rds_engine_version" "postgres" {
  engine             = "postgres"
  preferred_versions = ["16.6"]
}

data "aws_rds_orderable_db_instance" "main" {
  engine                     = data.aws_rds_engine_version.postgres.engine
  storage_type               = var.db_storage_type
  engine_version             = data.aws_rds_engine_version.postgres.version
  preferred_instance_classes = [var.db_instance_class]
}

data "external" "rds_final_snapshot_exists" {
  program = [
    "sh",
    "${path.module}/check-rds-snapshot.sh",
    local.db_identifier
  ]
}

data "aws_db_snapshot" "latest" {
  count                  = data.external.rds_final_snapshot_exists.result.db_exists ? 1 : 0
  most_recent            = true
  db_instance_identifier = local.db_identifier
}

resource "aws_db_instance" "main" {
  identifier                = local.db_identifier
  allocated_storage         = var.db_allocated_storage
  storage_type              = data.aws_rds_orderable_db_instance.main.storage_type
  engine                    = data.aws_rds_engine_version.postgres.engine
  engine_version            = data.aws_rds_engine_version.postgres.version
  instance_class            = data.aws_rds_orderable_db_instance.main.instance_class
  username                  = var.db_username
  password                  = var.db_password
  parameter_group_name      = "default.postgres16"
  db_name                   = var.db_name
  port                      = var.db_port
  publicly_accessible       = var.publicly_accessible
  vpc_security_group_ids    = [var.db_sg_id]
  db_subnet_group_name      = aws_db_subnet_group.main.name
  snapshot_identifier       = try(data.aws_db_snapshot.latest.0.id, null)
  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.db_identifier}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  tags = merge(local.tags, {
    Name = local.db_identifier
  })

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
      snapshot_identifier
    ]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.db_identifier}-subnet-group"
  subnet_ids = var.database_subnet_ids
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.environment}/db/password"
  description = "Password for the database"
  type        = "SecureString"
  value       = var.db_password

  tags = merge(local.tags, {
    Name = "/${var.environment}/db/password"
  })
}


