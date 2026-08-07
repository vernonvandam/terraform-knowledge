# Configuration management

Configuration management separates the reusable Terraform implementation from values that differ by environment or deployment.

Use variables for an explicit root-module interface, `locals` for derived values, and versioned non-secret variable files where they are appropriate. Keep secrets in an approved secret-management or CI identity system, not in repository files.

```hcl
locals {
  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
```

Avoid using the working directory, an implicit workspace, or undocumented environment variables as hidden configuration. Document the source of each material value, validate input early, and review every configuration change as infrastructure code.