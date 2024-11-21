resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "${local.name_prefix}-cf-logs"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-cf-logs"
  })
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "web" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
