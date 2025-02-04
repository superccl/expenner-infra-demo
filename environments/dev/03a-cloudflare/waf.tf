resource "cloudflare_leaked_credential_check" "main" {
  zone_id = data.cloudflare_zone.selected.id
  enabled = true
}

resource "cloudflare_ruleset" "rate_limiting_example" {
  zone_id     = data.cloudflare_zone.selected.id
  name        = "Rate limit ruleset"
  description = ""
  phase       = "http_ratelimit"
  kind        = "zone"

  rules {
    ref         = "rate_limit_api_requests"
    description = "Rate limit API requests by IP"
    expression  = "(http.request.uri.path wildcard \"/api/*\")"
    action      = "block"
    ratelimit {
      characteristics = [
        "cf.colo.id",
        "ip.src"
      ]
      period              = 10
      requests_per_period = 30
      mitigation_timeout  = 10
    }
  }
}

resource "cloudflare_ruleset" "block_non_allowed_ip" {
  zone_id     = data.cloudflare_zone.selected.id
  name        = "Block IPs and firewall"
  description = "Block non allowed IP ruleset, "
  phase       = "http_request_firewall_custom"
  kind        = "zone"

  rules {
    ref         = "block_non_allowed_ip"
    description = "Block non allowed IP"
    expression  = "(starts_with(http.host, \"${var.domain_name}\") and ip.src ne ${data.http.myip.response_body})"
    action      = "block"
  }

  rules {
    ref         = "block_known_bots"
    description = "Block known bots"
    expression  = "(cf.client.bot)"
    action      = "block"
  }
}
