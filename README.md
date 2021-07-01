Terraform Module: Google DNS
----------------------------

A Terraform module for [Google Cloud Platform](https://cloud.google.com/) that makes it easy to create and modify
managed zones and records in [Cloud DNS](https://cloud.google.com/dns).

# Table of Contents

* [Introduction](#introduction)
* [Requirements](#requirements)
* [Usage](#usage)
* [Inputs](#inputs)
* [Outputs](#outputs)

# Introduction

This Terraform module is a simple wrapper around the [Google Cloud Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
that makes it really easy to create & manage DNS zones. It defines sensible defaults, and handles some of the formatting
of records for you.

# Requirements

* Terraform >= 0.14
* Google Cloud Provider

# Usage

All possible arguments are shown below. Optional arguments are shown with what is used to calculate their default value
if it is not supplied.

```terraform
module my_dns_zone {
  source = "garbetjie/dns/google"
  version = "~> 1"
  
  // Required arguments
  domain = "example.org"
  
  // Optional arguments
  name = replace(trimsuffix(var.domain, "."), ".", "-")
  description = "Managed zone for ${var.name} (managed by terraform)"
  labels = {}
  default_ttl = 300
  dnssec_enabled = false
  private = false
  networks = []
  records = []
  lowercase = true
}
```

# Inputs

| Name              | Description                                                                                                                                                                                                             | Type                                                                                           | Default           | Required |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|-------------------|----------|
| domain            | Domain to manage DNS for.                                                                                                                                                                                               | string                                                                                         |                   | Yes      |
| description       | Description to add to the managed zone.                                                                                                                                                                                 | string                                                                                         | `null`            | No       |
| default_ttl       | Default TTL to use for records when `records.*.ttl` is not supplied.                                                                                                                                                    | number                                                                                         | `300`             | No       |
| dnssec_enabled    | Whether or not to enable DNSSEC. Ignored when `var.private` is true.                                                                                                                                                    | bool                                                                                           | `false`           | No       |
| labels            | Labels to apply to the managed zone.                                                                                                                                                                                    | map(string)                                                                                    | `{}`              | No       |
| lowercase         | Force values in records to be lowercase (excluding values for TXT and SPF record types).                                                                                                                                | bool                                                                                           | `true`            | No       |
| name              | Name of the managed zone.                                                                                                                                                                                               | string                                                                                         | `null`            | No       |
| private           | Create this managed zone for internal use only.                                                                                                                                                                         | bool                                                                                           | `false`           | No       |
| networks          | List of networks in which to ensure the managed zone is available when it is a private zone. Values can either be a network name in the current provider project, or a network ID for a network in a different project. | set(string)                                                                                    | `[]`              | No       |
| records           | Records to add to the managed zone.                                                                                                                                                                                     | set(object({type=string, name=string, rrdatas=optional(list(string)), ttl=optional(number) })) | `[]`              | No       |
| records.*.type    | Type of DNS record.                                                                                                                                                                                                     | string                                                                                         |                   | Yes      |
| records.*.name    | Subdomain of the DNS record. Values of `null`, `""` or `"@"` will point to the root domain of the managed zone.                                                                                                         | string                                                                                         |                   | Yes      |
| records.*.rrdatas | Value of the DNS record.                                                                                                                                                                                                | list(string)                                                                                   |                   | No       |
| records.*.ttl     | TTL of the DNS record.                                                                                                                                                                                                  | number                                                                                         | `var.default_ttl` | No       |

# Outputs

All inputs are exported as outputs. There are additional outputs as defined below:

| Name         | Description                                         |
|--------------|-----------------------------------------------------|
| domain       | Domain used for this managed zone.                  |
| name_servers | Name servers to be used for this managed zone.      |
| network_urls | Links of networks the managed zone is available in. |
