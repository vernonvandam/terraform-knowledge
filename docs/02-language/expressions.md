# Expressions

Expressions calculate values from literals, variables, resources, data sources, locals, operators, functions, and `for` expressions.

```hcl
locals {
  endpoint = "https://${var.hostname}:${var.port}"
  enabled  = var.environment == "production" && var.monitoring_enabled
}
```

Terraform evaluates an expression as early as it can. Values derived from a resource created during an apply can be unknown during planning. A collection used by `for_each` or `count` must have known keys or length at plan time.

Prefer straightforward expressions. Move repeated or multi-stage expressions to `locals`, and use parentheses when they make precedence clear.