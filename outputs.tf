output name_servers {
  value = google_dns_managed_zone.managed_zone.name_servers
}

output domain {
  value = local.domain_without_dot
}

output network_urls {
  value = local.network_urls
}
