output name_servers {
  value = google_dns_managed_zone.managed_zone.name_servers
  description = "Name servers to be used for this managed zone."
}

output domain {
  value = local.domain_without_dot
  description = "Domain used for this managed zone."
}
