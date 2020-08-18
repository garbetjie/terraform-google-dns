resource google_dns_managed_zone managed_zone {
  dns_name = "${local.domain_without_dot}."
  name = var.name == null ? replace(local.domain_without_dot, ".", "-") : var.name
  description = var.description == null ? "Managed zone for ${local.domain_without_dot} (managed by terraform)" : var.description
  labels = var.labels
}

resource google_dns_record_set dns_records {
  for_each = local.record_sets
  managed_zone = google_dns_managed_zone.managed_zone.name
  name = "${split("/", each.key)[1]}${google_dns_managed_zone.managed_zone.name}"
  rrdatas = each.value.rrdatas
  type = split("/", each.key)[0]
  ttl = lookup(each.value, "ttl", 300)
}
