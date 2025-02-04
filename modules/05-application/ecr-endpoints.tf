# ##############################
# # VPC Endpoint (ecr.dkr)
# ##############################
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   security_group_ids = [var.vpc_endpoints_sg_id]
#   subnet_ids         = var.application_subnet_ids

#   tags = merge(local.tags, {
#     "Name" = "ecr-dkr"
#   })
# }

# ##############################
# # VPC Endpoint (ecr.api)
# ##############################
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   security_group_ids = [var.vpc_endpoints_sg_id]
#   subnet_ids         = var.application_subnet_ids

#   tags = merge(local.tags, {
#     "Name" = "ecr-api"
#   })
# }

# ##############################
# # VPC Endpoint (logs)
# ##############################
# resource "aws_vpc_endpoint" "ecr_logs" {
#   vpc_id              = var.vpc_id
#   service_name        = "com.amazonaws.${var.region}.logs"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   security_group_ids = [var.vpc_endpoints_sg_id]
#   subnet_ids         = var.application_subnet_ids

#   tags = merge(local.tags, {
#     "Name" = "ecr-logs"
#   })
# }

# data "aws_route_table" "selected" {
#   vpc_id = var.vpc_id
#   filter {
#     name   = "association.main"
#     values = ["true"]
#   }
# }

# ##############################
# # VPC Endpoint (s3)
# ##############################
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = var.vpc_id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"

#   route_table_ids = [data.aws_route_table.selected.id]

#   tags = merge(local.tags, {
#     "Name" = "ecr-s3"
#   })
# }
