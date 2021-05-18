output name_servers {
  value = google_dns_managed_zone.managed_zone.name_servers
  description = "Name servers to be used for this managed zone."
}

output domain {
  value = local.domain_without_dot
  description = "Domain used for this managed zone."
}

output network_urls {
  value = google_dns_managed_zone.managed_zone.private_visibility_config.networks.*.network_url
  description = "Links of networks the managed zone is available in."
}

output name {
  value = google_dns_managed_zone.managed_zone.name
  description = "Name of the managed zone."
}

output description {
  value = google_dns_managed_zone.managed_zone.description
  description = "Description of the managed zone."
}

output labels {
  value = google_dns_managed_zone.managed_zone.labels
  description = "Labels applied to the managed zone."
}

output default_ttl {
  value = var.default_ttl
  description = "Default TTL used for records without a TTL specified."
}

output dnssec_enabled {
  value = google_dns_managed_zone.managed_zone.dnssec_config.state == "on"
  description = "Whether or not DNSSEC is enabled on the managed zone."
}

output private {
  value = google_dns_managed_zone.managed_zone.visibility == "private"
  description = "The managed zone is a private zone."
}

output networks {
  value = var.networks
  description = "Network the managed zone is available in, as provided."
}

output records {
  value = local.records
  description = "The records that are used in the managed zone."
}

output lowercase {
  value = var.lowercase
  description = "Record names and values (excluding SPF & TXT record values) have been lowercased."
}