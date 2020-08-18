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
  type = map(object({ rrdatas = list(string) }))
  default = {}
}

variable CNAME {
  type = map(object({ rrdatas = list(string) }))
  default = {}
}

variable TXT {
  type = map(object({ rrdatas = list(string) }))
  default = {}
}

variable NS {
  type = map(object({ rrdatas = list(string) }))
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
        each.key == "" || each.key == "@" ? "A/" : "A/${trimsuffix(each.key, ".")}" => value
    },
    {
      for key, value in var.CNAME:
        each.key == "" || each.key == "@" ? "CNAME/" : "CNAME/${trimsuffix(each.key, ".")}" => value
    },
    {
      for key, value in var.TXT:
        each.key == "" || each.key == "@" ? "TXT/" : "TXT/${trimsuffix(each.key, ".")}" => value
    },
    {
      for key, value in var.NS:
        each.key == "" || each.key == "@" ? "NS/" : "NS/${trimsuffix(each.key, ".")}" => value
    }
  )
}
