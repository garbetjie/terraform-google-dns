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

variable A {
  type = map(object({ rrdata = list(string) }))
  default = {}
}

variable CNAME {
  type = map(object({ rrdata = list(string) }))
  default = {}
}

variable TXT {
  type = map(object({ rrdata = list(string) }))
  default = {}
}

variable NS {
  type = map(object({ rrdata = list(string) }))
  default = {}
}

variable labels {
  type = map(string)
  default = {}
}

locals {
  domain_without_dot = trimsuffix(var.domain, ".")
  # name = "${each.key == "" ? "" : "${each.key}."}${google_dns_managed_zone.managed_zone.dns_name}"

  record_sets = merge(
    {
      for key, value in var.A:
        key == "" || key == "@" ? "A/" : "A/${trimsuffix(key, ".")}." => value
    },
    {
      for key, value in var.CNAME:
        key == "" || key == "@" ? "CNAME/" : "CNAME/${trimsuffix(key, ".")}." => value
    },
    {
      for key, value in var.TXT:
        key == "" || key == "@" ? "TXT/" : "TXT/${trimsuffix(key, ".")}." => value
    },
    {
      for key, value in var.NS:
        key == "" || key == "@" ? "NS/" : "NS/${trimsuffix(key, ".")}." => value
    }
  )
}
