# `for_each`

## Problem

Create similar resources while preserving each instance's stable business identity.

## Implementation

```hcl
resource "random_pet" "service" {
  for_each = toset(["api", "worker"])
  prefix   = each.key
  length   = 2
}
```

Use maps or sets with meaningful keys. Avoid it for an intentionally ordered, indistinguishable list. Addresses include the key, so changing a key requires a `moved` block or produces a delete/create change.