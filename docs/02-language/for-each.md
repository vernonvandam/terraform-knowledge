# `for_each`

`for_each` creates one resource or module instance for each key in a map or member of a set. Each instance has a stable key-based address.

```hcl
resource "random_pet" "service" {
  for_each = toset(["api", "worker"])
  prefix   = each.key
  length   = 2
}
```

Use `each.key` and `each.value` inside the block. Prefer `for_each` when instances have business-meaningful identities; adding or removing a key does not remap the others. Keys must be known before apply and must not contain sensitive values.

Changing a key changes an address. Preserve identity with a `moved` block during a deliberate rename. See the [pattern](../../patterns/for-each/README.md) for design trade-offs.