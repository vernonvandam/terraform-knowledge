# Functions

Terraform functions transform and inspect values. Common examples include `merge`, `lookup`, `try`, `coalesce`, `format`, `lower`, `trimspace`, `toset`, and `jsonencode`.

```hcl
locals {
  tags = merge(var.default_tags, var.service_tags)
  name = lower(replace(trimspace(var.display_name), " ", "-"))
}
```

Use functions to express a clear transformation, not to conceal complex business logic. Prefer direct attribute access when an attribute is required; reserve `try` for genuinely optional or legacy input shapes. Be wary of `file` and similar functions: their inputs are read from the configuration directory and must be available during planning.

Refer to the official Terraform function reference for precise type and error behaviour.