resource "aws_ecr_repository" "app" {
  name                 = "${local.name_prefix}-server"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-server-ecr"
  })
}
