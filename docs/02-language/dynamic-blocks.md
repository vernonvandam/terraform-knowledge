# Dynamic blocks

A `dynamic` block generates repeated nested blocks inside a resource, data source, provider, or provisioner. It is useful only when the provider schema expects nested blocks.

```hcl
dynamic "setting" {
  for_each = var.settings
  content {
    name  = setting.key
    value = setting.value
  }
}
```

Use a descriptive iterator when nesting dynamic blocks. Prefer ordinary expressions when the provider accepts an argument value directly; dynamic blocks cannot generate meta-arguments such as `lifecycle` or `provisioner`.

Do not use a dynamic block merely to avoid writing a small fixed set of nested blocks. Overuse hides configuration shape and makes plans harder to review.