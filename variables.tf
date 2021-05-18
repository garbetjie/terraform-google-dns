variable domain {
  type = string
  description = "Domain to manage DNS for."
}

variable name {
  type = string
  default = null
  description = "Name of the managed zone. Defaults to $${replace(var.domain, \".\", \"-\")}."
}

variable description {
  type = string
  default = null
  description = "Description to add to the managed zone."
}

variable labels {
  type = map(string)
  default = {}
  description = "Labels to apply to the managed zone."
}

variable default_ttl {
  type = number
  default = 300
  description = "Default TTL to use for records when records.ttl is defined as `null`."
}

variable dnssec_enabled {
  type = bool
  default = false
  description = "Whether or not to enable DNSSEC. Ignored when var.private is true."
}

variable private {
  type = bool
  default = false
  description = "Create this managed zone for internal use only."
}

variable networks {
  type = list(string)
  default = []
  description = "List of networks in which to ensure the managed zone is available when it is a private zone."
}

variable records {
  type = list(object({ type = string, name = string, rrdatas = list(string), ttl = number }))
  default = []
  description = "Records to add to the managed zone."
}

