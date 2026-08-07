# Module composition

Composition connects small modules through explicit inputs and outputs rather than exposing internal resources or sharing implementation details.

```hcl
module "network" {
  source = "../../modules/network"
  cidr   = var.network_cidr
}

module "service" {
  source    = "../../modules/service"
  subnet_id = module.network.private_subnet_id
}
```

Output references create an implicit dependency, so Terraform orders the graph correctly. Keep the dependency direction clear: foundations such as networks should not depend on application modules. Avoid circular dependencies and use an orchestration root module when several components must be assembled.

Pass provider aliases explicitly to a child module when it must use a non-default configuration.