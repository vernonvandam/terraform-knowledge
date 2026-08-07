# Reusable modules

Use a module for a cohesive capability with a credible additional consumer or a useful ownership boundary. Define typed inputs, intentional outputs, and no provider configuration.

```hcl
module "service" {
  source = "../../modules/service"
  name   = "api"
}
```

Avoid a module solely to hide a few lines of one-off configuration. A module is an API: keep defaults conservative, document its contract, test it, and version breaking changes.