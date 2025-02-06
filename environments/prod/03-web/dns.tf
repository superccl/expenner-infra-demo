data "cloudflare_zone" "selected" {
  name = var.root_domain
}

resource "cloudflare_record" "cname" {
  for_each = toset(["", "www."])
  zone_id  = data.cloudflare_zone.selected.id
  name     = "${each.value}${var.domain_name}"
  type     = "CNAME"
  content  = module.web.cloudfront_domain_name
}
