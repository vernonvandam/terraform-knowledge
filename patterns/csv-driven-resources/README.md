# CSV-driven resources

## Problem

Create a predictable resource set from an approved, versioned table.

```hcl
locals {
  records = {
    for row in csvdecode(file("${path.module}/records.csv")) :
    row.name => { enabled = lower(trimspace(row.enabled)) == "true" }
  }
}
```

Iterate over a map keyed by a unique column. Use this only for small, non-secret, stable input. CSV has weak types: validate required columns, normalise whitespace, and fail early on duplicate keys.