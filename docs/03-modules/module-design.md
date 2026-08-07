# Module design

Design a module as a small product with an explicit contract. It should own one cohesive capability, accept typed inputs, expose intentional outputs, and make safe defaults clear.

```hcl
module "service" {
  source = "../../modules/service"

  name        = "api"
  environment = var.environment
  tags        = local.common_tags
}
```

Prefer composition over a large "do everything" module. Do not configure providers inside reusable modules; callers need to control credentials, regions, aliases, and lifecycle. Preserve resource addresses across releases or provide `moved` blocks and migration guidance.

Test the public contract, document assumptions and side effects, and use semantic versioning for published modules.