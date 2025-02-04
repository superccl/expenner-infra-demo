data "cloudflare_zone" "selected" {
  name = var.root_domain
}

resource "cloudflare_record" "cname" {
  for_each = toset(["www", "@"])
  zone_id  = data.cloudflare_zone.selected.id
  name     = each.key
  type     = "CNAME"
  content  = data.terraform_remote_state.web.outputs.cloudfront_domain_name
}
