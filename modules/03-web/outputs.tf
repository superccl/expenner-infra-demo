output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "load_balancer_dns_name" {
  value = aws_lb.web.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.web.arn
}


output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "domain_name" {
  value = var.domain_name
}

output "container_port" {
  value = var.container_port
}
