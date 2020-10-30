Terraform Module: Google DNS
----------------------------

A Terraform module for [Google Cloud Platform](https://cloud.google.com/) that makes it easy to modify managed zones and
records in [Cloud DNS](https://cloud.google.com/dns).

## Inputs

| Name              | Description                                                                                                     | Type                                                                         | Default                         | Required |
|-------------------|-----------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|---------------------------------|----------|
| domain            | Domain to manage DNS for.                                                                                       | string                                                                       |                                 | Yes      |
| name              | Name of the managed zone.                                                                                       | string                                                                       | `replace(var.domain, ".", "-")` | No       |
| description       | Description to add to the managed zone.                                                                         | string                                                                       | `null`                          | No       |
| labels            | Labels to apply to the managed zone.                                                                            | map(string)                                                                  | `{}`                            | No       |
| default_ttl       | Default TTL to use for records when `records.ttl` is defined as `null`.                                         | number                                                                       | `300`                           | No       |
| dnssec_enabled    | Whether or not to enable DNSSEC. Ignored when `${var.private}` is true.                                         | bool                                                                         | `false`                         | No       |
| private           | Create this managed zone for internal use only.                                                                 | bool                                                                         | `false`                         | No       |
| networks          | List of networks in which to ensure the managed zone is available when it is a private zone.                    | list(string)                                                                 | `[]`                            | No       |
| records           | Records to add to the managed zone.                                                                             | list(object({ type=string, name=string, rrdatas=list(string), ttl=number })) | `[]`                            | No       |
| records[].type    | Type of DNS record.                                                                                             | string                                                                       |                                 | Yes      |
| records[].name    | Subdomain of the DNS record. Values of `null`, `""` or `"@"` will point to the root domain of the managed zone. | string                                                                       |                                 | Yes      |
| records[].rrdatas | Value of the DNS record.                                                                                        | list(string)                                                                 |                                 | Yes      |
| records[].ttl     | TTL of the DNS record.                                                                                          | number                                                                       | `${var.default_ttl}`            | No       |

## Outputs

| Name         | Description                                    |
|--------------|------------------------------------------------|
| name_servers | Name servers to be used for this managed zone. |
| domain       | Domain used for this managed zone.             |
