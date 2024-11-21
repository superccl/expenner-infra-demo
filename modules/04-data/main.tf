locals {
  tags = {
    Tier        = "04-data"
    Environment = var.environment
    Create_date = formatdate("YYYY-MM-DD", timestamp())
    Created_by  = "Terraform"
    Region      = var.region
  }
}

data "aws_rds_engine_version" "postgres" {
  engine = "postgres"
  latest = true
}

data "aws_rds_orderable_db_instance" "main" {
  engine                     = data.aws_rds_engine_version.postgres.engine
  storage_type               = var.db_storage_type
  engine_version             = data.aws_rds_engine_version.postgres.version
  preferred_instance_classes = [var.db_instance_class]
}

resource "aws_db_instance" "main" {
  identifier             = var.db_identifier
  allocated_storage      = var.db_allocated_storage
  storage_type           = data.aws_rds_orderable_db_instance.main.storage_type
  engine                 = data.aws_rds_engine_version.postgres.engine
  engine_version         = data.aws_rds_engine_version.postgres.version
  instance_class         = data.aws_rds_orderable_db_instance.main.instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres16"
  db_name                = var.db_name
  port                   = var.db_port
  publicly_accessible    = false
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  tags = merge(local.tags, {
    Name = var.db_identifier
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.db_identifier}-subnet-group"
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


