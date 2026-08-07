# Naming standards

Names should communicate ownership and preserve stable resource identity. Use `snake_case` for Terraform identifiers and names that describe the managed object, not its implementation history.

```hcl
variable "service_name" {
  type = string
}

resource "aws_iam_role" "application" {
  name = "${var.environment}-${var.service_name}"
}
```

Use plural names for collections and singular names for one object. Choose stable `for_each` keys such as account IDs, service names, or DNS names; changing a key changes the resource address. Establish provider-level naming conventions separately for externally visible names, including length, casing, and regional uniqueness constraints.