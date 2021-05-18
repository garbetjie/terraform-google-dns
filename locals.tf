locals {
  domain_without_dot = trimsuffix(var.domain, ".")

  // First, fill & format all the records with default values.
  _filled_records = [for record in var.records: {
    name = record.name == null || record.name == "@" || record.name == "" ? "" : "${trimsuffix(record.name, ".")}.",
    type = upper(record.type)
    ttl = lookup(record, "ttl", var.default_ttl)
    rrdatas = lookup(record, "rrdatas", [])
  }]

  // Then, go and modify case if necessary.
  records = [for record in local._filled_records: {
    name = var.lowercase ? lower(record.name) : record.name
    type = record.type
    ttl = record.ttl == null ? var.default_ttl : record.ttl
    rrdatas = [for data in record.rrdatas:
      var.lowercase && !contains(["TXT", "SPF"], record.type) ? lower(data) : data
    ]
  }]

  // Convert simple network names (like "default") to network IDs based on the current project.
  network_urls = [for network in var.networks:
    length(regexall("/", network)) > 0 ? network : "projects/${data.google_project.current_project.project_id}/global/networks/${network}"
  ]
}
