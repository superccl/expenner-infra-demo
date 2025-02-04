locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "02-storage"
    Environment = var.environment
    Created_by  = "Terraform"
    Region      = var.region
  }
}

resource "aws_s3_bucket" "web" {
  bucket = var.web_bucket_name
  tags = merge(local.tags, {
    Name = "${var.web_bucket_name}-s3-bucket"
  })
}

resource "aws_s3_bucket_ownership_controls" "web" {
  bucket = aws_s3_bucket.web.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}

resource "aws_s3_bucket_public_access_block" "web" {
  bucket = aws_s3_bucket.web.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
