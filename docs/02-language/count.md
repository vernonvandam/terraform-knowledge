# `count`

`count` creates a numbered sequence of resource or module instances. Access the current index with `count.index`.

```hcl
resource "terraform_data" "feature" {
  count = var.enable_feature ? 1 : 0
  input = "enabled"
}
```

Use `count` for optional single resources or truly interchangeable instances. For collections with stable identities, prefer `for_each`: removing an item from the middle of a list can shift indices and cause unintended replacement.

References require an index, such as `terraform_data.feature[0]`. Guard those references when `count` can be zero, or expose a safer output with `try` where that optionality is part of the contract.