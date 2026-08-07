# Terraform overview

Terraform is infrastructure as code: configuration files describe desired infrastructure and Terraform records the mapping between configuration addresses and real objects in state. A directory of `.tf` files is a root module.

- Providers translate Terraform operations into API calls.
- Resources declare objects Terraform owns.
- Data sources read objects managed elsewhere.
- Modules package configuration behind inputs and outputs.
- State records identities and must be protected.

Terraform is declarative. References express dependencies; use `depends_on` only when the dependency is real but invisible in arguments.

```hcl
terraform {
  required_version = "~> 1.15.0"
}
```