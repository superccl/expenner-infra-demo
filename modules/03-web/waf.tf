resource "aws_wafv2_web_acl" "cloudfront" {
  name        = "cf-waf"
  description = "Web ACL with IP and header rules"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.environment == "prod" ? [] : [1]

    content {
      name     = "block-non-allowed-ip"
      priority = 0
      action {
        block {}
      }

      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.ipset[0].arn
            }
          }

        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "block-non-allowed-ip"
        sampled_requests_enabled   = true
      }
    }
  }

  rule {
    name     = "rate-limit"
    priority = 3
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 300
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cf-waf"
    sampled_requests_enabled   = true
  }

  tags = merge(local.tags, {
    Name = "cf-waf"
  })

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_wafv2_ip_set" "ipset" {
  count              = var.environment == "prod" ? 0 : 1
  name               = "cf-ipset"
  description        = "IP set for allowed IPs"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ips

  tags = merge(local.tags, {
    Name = "cf-ipset"
  })
}
