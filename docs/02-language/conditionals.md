# Conditionals

A conditional expression chooses one of two values based on a boolean condition.

```hcl
locals {
  instance_size = var.environment == "production" ? "large" : "small"
}
```

Both result branches must have compatible types. Prefer a short conditional for one clear policy choice; use a map lookup or a local when several environments or cases would make a nested conditional hard to read.

Conditional resource creation has lifecycle implications. A false condition can remove a managed resource from configuration and propose its destruction. Review that plan carefully.