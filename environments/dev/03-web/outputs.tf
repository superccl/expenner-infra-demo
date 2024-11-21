output "cloudfront_distribution_id" {
  value = module.web.cloudfront_distribution_id
}

output "load_balancer_dns_name" {
  value = module.web.load_balancer_dns_name
}

output "load_balancer_arn" {
  value = module.web.load_balancer_arn
}

output "target_group_arn" {
  value = module.web.target_group_arn

}

output "acm_certificate_arn" {
  value = module.web.acm_certificate_arn
}

output "domain_name" {
  value = module.web.domain_name
}

output "container_port" {
  value = module.web.container_port
}
