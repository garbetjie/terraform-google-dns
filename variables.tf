variable domain {
  type = string
}

variable name {
  type = string
  default = null
}

variable description {
  type = string
  default = null
}

variable labels {
  type = map(string)
  default = {}
}

variable default_ttl {
  type = number
  default = 300
}

variable dnssec_enabled {
  type = bool
  default = false
}

variable private {
  type = bool
  default = false
}

variable networks {
  type = list(string)
  default = []
}

variable records {
  type = list(object({ type = string, name = string, rrdatas = list(string), ttl = number }))
  default = []
}

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
