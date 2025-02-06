data "cloudflare_zone" "selected" {
  name = var.root_domain
}

# resource "cloudflare_record" "ns" {
#   for_each = toset(data.terraform_remote_state.web.outputs.name_servers)
#   zone_id  = data.cloudflare_zone.selected.id
#   name     = local.subdomain
#   type     = "NS"
#   content  = each.key
# }
