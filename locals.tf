locals {
  domain_without_dot = trimsuffix(var.domain, ".")
  # name = "${each.key == "" ? "" : "${each.key}."}${google_dns_managed_zone.managed_zone.dns_name}"

  records = {
  for record in var.records:
    format("%s/%s", record.type, record.name == null || record.name == "@" || record.name == "" ? "" : "${trimsuffix(record.name, ".")}.") => {
      name = record.name == null || record.name == "@" || record.name == "" ? "" : "${trimsuffix(record.name, ".")}.",
      type = record.type,
      ttl = record.ttl != null ? record.ttl : var.default_ttl,
      rrdatas = record.rrdatas
    }
  }

  network_urls = [
    for network in var.networks:
      length(regexall("/", network)) > 0 ? network : "projects/${data.google_project.current_project.project_id}/global/networks/${network}"
  ]
}
