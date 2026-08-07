# Version and provider assumptions

This repository targets the current stable Terraform CLI line, **Terraform 1.15.x**. CI uses **1.15.8**.

Root modules use a bounded minor-line constraint:

```hcl
terraform {
  required_version = "~> 1.15.0"
}
```

Reusable modules normally set only their tested minimum version. Every module declares a source address and compatibility constraint for each provider; root modules set the upper bound and child modules inherit provider configuration.

Commit `.terraform.lock.hcl` for every root module. It records selected provider versions and checksums. Update it deliberately with `terraform init`; use `terraform init -upgrade` only as a reviewed upgrade. Lock files do not pin remote module selections, so pin external module versions explicitly.

See HashiCorp guidance on [provider requirements](https://developer.hashicorp.com/terraform/language/providers/requirements), [version constraints](https://developer.hashicorp.com/terraform/language/expressions/version-constraints), and [dependency lock files](https://developer.hashicorp.com/terraform/language/files/dependency-lock).