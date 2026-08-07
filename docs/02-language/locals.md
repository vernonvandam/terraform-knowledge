# Locals

Locals give a name to derived expressions used within one module. They are not user-configurable inputs and are not exported as a module API.

```hcl
locals {
  name_prefix = "${var.environment}-${var.service_name}"
  common_tags = merge(var.tags, { environment = var.environment })
}
```

Use locals to reduce repeated transformations, normalise input, and make resource blocks easier to read. Keep them close to their consumer and choose names that describe the result. Avoid turning every literal into a local: a value used once is usually clearer inline.

For a multi-step collection transformation, use named locals rather than one deeply nested expression.