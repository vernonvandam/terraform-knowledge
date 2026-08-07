# Provider versioning

Declare each provider's source address and version constraint in the `terraform` block.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Root modules should bound the provider version so teams upgrade deliberately. Reusable modules should normally state only a tested minimum, allowing their consumers to select a compatible newer version. Commit `.terraform.lock.hcl` in each root module to record the selected provider versions and checksums.

Review provider release notes and the plan during upgrades. Do not use an unbounded provider requirement in production roots.