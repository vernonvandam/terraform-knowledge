# Variables

Variables make a root module or reusable module configurable. Define a type, description, and validation where it prevents an unsafe or confusing plan.

```hcl
variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["development", "production"], var.environment)
    error_message = "Environment must be development or production."
  }
}
```

Set root-module values with `*.tfvars`, `-var-file`, environment variables such as `TF_VAR_environment`, or a documented CI mechanism. Do not commit secrets in variable files. Use `sensitive = true` for secret inputs, remembering that this only redacts CLI output; state still needs protection.

Prefer explicit typed inputs over untyped `any`. Use an object when several values form one domain concept; see [nested objects](../../patterns/nested-objects/README.md).