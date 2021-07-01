locals {
  domain_without_dot = trimsuffix(var.domain, ".")

  records = [
    for record in var.records: {
      name = coalesce(record.name, "@") == "@" ? "" : "${var.lowercase ? lower(trimsuffix(record.name, ".")) : trimsuffix(record.name, ".")}."
      type = upper(record.type)
      ttl = lookup(record, "ttl", var.default_ttl) == null ? var.default_ttl : lookup(record, "ttl", var.default_ttl)
      rrdatas = [
        for data in (lookup(record, "rrdatas", []) == null ? [] : lookup(record, "rrdatas", [])):
          var.lowercase && !contains(["TXT", "SPF"], upper(record.type)) ? lower(data) : data
      ]
    }
  ]
}
