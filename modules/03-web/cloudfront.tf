locals {
  s3_origin_id  = "S3 Origin"
  app_domain_id = "Custom Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = data.aws_s3_bucket.web.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
    origin_id                = local.s3_origin_id

  }

  origin {
    domain_name = aws_lb.web.dns_name
    origin_id   = local.app_domain_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    custom_header {
      name  = var.header_name
      value = var.header_value
    }
  }

  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = "index.html"
  price_class         = var.cloudfront_price_class
  comment             = "Managed by Terraform"
  aliases             = [var.domain_name, "www.${var.domain_name}"]
  web_acl_id          = aws_wafv2_web_acl.cloudfront.arn
  depends_on          = [aws_wafv2_web_acl.cloudfront, aws_acm_certificate_validation.cert]


  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    cache_policy_id        = data.aws_cloudfront_cache_policy.s3.id
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect_www.arn
    }
  }
  ordered_cache_behavior {
    path_pattern             = "/api/*"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.app_domain_id
    cache_policy_id          = data.aws_cloudfront_cache_policy.api.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.api.id
    viewer_protocol_policy   = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-cf"
  })

  logging_config {
    bucket          = aws_s3_bucket.cloudfront_logs.bucket_domain_name
    prefix          = "cf-logs/"
    include_cookies = false
  }
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "s3-origin-access-control"
  description                       = "Managed by Terraform"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "s3" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "api" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "api" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_function" "redirect_www" {
  name    = "redirect-www-to-root"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/redirect-www.js")

  lifecycle {
    ignore_changes = [code]
  }
}

resource "aws_ssm_parameter" "distribution_id" {
  name        = "/${var.environment}/cloudfront/distribution-id"
  description = "ID of the CloudFront distribution"
  type        = "String"
  value       = aws_cloudfront_distribution.s3_distribution.id

  tags = merge(local.tags, {
    Name = "/${var.environment}/cloudfront/distribution-id"
  })
}
