resource google_dns_managed_zone managed_zone {
  dns_name = "${local.domain_without_dot}."
  name = coalesce(var.name, replace(local.domain_without_dot, ".", "-"))
  description = coalesce(var.description, "Managed zone for ${local.domain_without_dot} (managed by terraform)")
  labels = var.labels

  dynamic "dnssec_config" {
    for_each = var.private ? [] : [var.dnssec_enabled ? "on" : "off"]
    content {
      state = dnssec_config.value
    }
  }

  // Private DNS configuration.
  visibility = var.private ? "private" : "public"

  dynamic "private_visibility_config" {
    for_each = var.private ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

resource google_dns_record_set dns_records {
  for_each = { for record in local.records: format("%s/%s", record.type, record.name) => record }

  managed_zone = google_dns_managed_zone.managed_zone.name
  name = "${each.value.name}${google_dns_managed_zone.managed_zone.dns_name}"
  rrdatas = each.value.rrdatas
  type = each.value.type
  ttl = each.value.ttl
}
