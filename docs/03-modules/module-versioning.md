# Module versioning

Version module sources so callers can upgrade deliberately and reproduce a known configuration.

```hcl
module "network" {
  source  = "app.terraform.io/example/network/aws"
  version = "~> 2.3"
}
```

For registry modules, use a version constraint appropriate to the release process. For Git sources, prefer an immutable tag or commit rather than a moving branch. Relative local modules are released with their caller and do not use a version argument.

Use semantic versioning: patch releases fix compatible behaviour, minor releases add compatible capability, and major releases can break a public contract. Publish migration notes for address moves, renamed variables, changed defaults, or replacement behaviour.